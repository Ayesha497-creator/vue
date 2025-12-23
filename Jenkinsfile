pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT     = "vue" 
        ENV_NAME    = "${BRANCH_NAME}"         
        TEST_BRANCH = "test" 
        SLACK_WEBHOOK = credentials('SLACK_WEBHOOK')
        QG_STATUS   = "NONE"
    }

    stages {
        stage('Quality Check (QA)') {
            when { branch "${TEST_BRANCH}" }
            steps {
                script {
                    echo "QA Scan starting for ${TEST_BRANCH}..."
                    withSonarQubeEnv('SonarQube-Server') {
                        sh """
                            ${tool 'sonar-scanner'}/bin/sonar-scanner \
                                -Dsonar.projectKey=${PROJECT}-project \
                                -Dsonar.sources=. \
                                -Dsonar.exclusions=**/node_modules/**,**/vendor/**
                        """
                    }
                    timeout(time: 10, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        env.QG_STATUS = qg.status
                        if (env.QG_STATUS != 'OK') {
                            error "STOPPING: QA Status is ${env.QG_STATUS}"
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                expression {
                    return (ENV_NAME != TEST_BRANCH) || (ENV_NAME == TEST_BRANCH && env.QG_STATUS == 'OK')
                }
            }
            steps {
                script {
                    sshagent(['jenkins-deploy-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
                                set -e
                                cd /var/www/html/${ENV_NAME}/${PROJECT}
                                git pull origin ${ENV_NAME}

                               case "${PROJECT}" in
                            "vue"|"next")
                                npm run build
                                if [ "${PROJECT}" = "next" ]; then
                                    pm2 restart "${PROJECT}-${ENV_NAME}" 
                                    pm2 save
                                fi
                                ;;
                            "laravel")
                                php artisan optimize
                                ;;
                        esac
                    '
                        """
                    }
                }
            }
        }
    }

    post {
        failure {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"❌ *${PROJECT}* (${ENV_NAME}): Failed!\"}' ${SLACK_WEBHOOK}"
        }
        success {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"✅ *${PROJECT}* (${ENV_NAME}): Success!\"}' $SLACK_WEBHOOK"
        }
    }
}
