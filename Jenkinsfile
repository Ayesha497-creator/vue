pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT     = "vue" 
        ENV_NAME    = "${BRANCH_NAME}"         
        TEST_BRANCH = "test" 
        SLACK_WEBHOOK = credentials('SLACK_WEBHOOK')
    }

    stages {
        stage('Quality check') {
            steps {
                script {
                    env.FAILURE_MSG = "Quality Gatekeeper"
                    sh "git checkout -f ${TEST_BRANCH} && git pull origin ${TEST_BRANCH}"
                    
                    withSonarQubeEnv('SonarQube-Server') {
                        sh """
                        export NODE_OPTIONS="--max-old-space-size=2048"
                        ${tool 'sonar-scanner'}/bin/sonar-scanner \
                            -Dsonar.projectKey=${PROJECT}-project \
                            -Dsonar.sources=. \
                            -Dsonar.exclusions=**/node_modules/**,**/vendor/**
                        """
                    }

                    timeout(time: 10, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "STOPPING DEPLOYMENT: Quality Gate failed on ${TEST_BRANCH}"
                        }
                    }
                }
            }
        }

        stage('Deploy Current Branch') {
            when { 
                expression { return currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                script {
                    env.FAILURE_MSG = "Deployment on ${ENV_NAME}"
                    def PROJECT_DIR = "/var/www/html/${ENV_NAME}/${PROJECT}"
                    
                    sshagent(['jenkins-deploy-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
                            set -e
                            cd ${PROJECT_DIR}
                            
                            git pull origin ${ENV_NAME}

                            case "${PROJECT}" in
                                "vue"|"next")
                                    npm run build
                                    if [ "${PROJECT}" = "next" ]; then
                                        pm2 restart "Next-${ENV_NAME}" 
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
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"❌ *${PROJECT}* Deployment Blocked! Test Branch Quality Failed.\"}' ${SLACK_WEBHOOK}"
        }
        success {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"✅ *${PROJECT}* (${ENV_NAME}) Deployed! (Verified via ${TEST_BRANCH}) 🚀\"}' $SLACK_WEBHOOK"
        }
    }
}
