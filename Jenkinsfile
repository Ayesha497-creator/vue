pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.62.178.120"
        PROJECT     = "vue" 
        ENV_NAME    = "${BRANCH_NAME}"         
        TEST_BRANCH = "test" 
        SLACK_WEBHOOK = credentials('SLACK_WEBHOOK')
    }

    stages {
        stage('Quality Check') {
            when { branch "${TEST_BRANCH}" }
            steps {
                script {
                    withSonarQubeEnv('SonarQube-Server') {
                        sh "${tool 'sonar-scanner'}/bin/sonar-scanner -Dsonar.projectKey=${PROJECT}-project -Dsonar.sources=. -Dsonar.exclusions=**/node_modules/**,**/vendor/**"
                    }
                    timeout(time: 10, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "QUALITY_GATE_FAILED" 
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sshagent(['jenkins-deploy-key']) {
                        sh """
                        ssh-keyscan -H ${REMOTE_HOST} >> ~/.ssh/known_hosts
                            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
                                set -e
                                cd /var/www/html/${ENV_NAME}/${PROJECT}
                                git pull origin ${ENV_NAME}

                                case "${PROJECT}" in
                                    "vue"|"next")
                                    npm install
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
            script {
                def failureType = "Deployment Stage"
                
                if (env.BRANCH_NAME == env.TEST_BRANCH) {
                     failureType = "Quality Check"
                }

                sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"❌ *${PROJECT}* (${ENV_NAME}) - *${failureType} Failed!*\"}' ${SLACK_WEBHOOK}"
            }
        }
        success {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"✅ *${PROJECT}* (${ENV_NAME}) - Deployed Successfully!\"}' ${SLACK_WEBHOOK}"
        }
    }
}
