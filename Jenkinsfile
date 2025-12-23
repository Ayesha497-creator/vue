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
        stage('Quality Check (QA)') {
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
            when {
                beforeAgent true
                expression {
                    return (BRANCH_NAME != TEST_BRANCH) || (currentBuild.result == null || currentBuild.result == 'SUCCESS')
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
            script {
                def failureType = "Deployment Stage"
                
                if (env.BRANCH_NAME == env.TEST_BRANCH && currentBuild.rawBuild.getLog(100).contains("QUALITY_GATE_FAILED")) {
                    failureType = "Quality Check (QA)"
                }

                sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"❌ *${PROJECT}* (${ENV_NAME}) - *${failureType} Failed!*\"}' ${SLACK_WEBHOOK}"
            }
        }
        success {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"✅ *${PROJECT}* (${ENV_NAME}) - Deployed Successfully!\"}' $SLACK_WEBHOOK"
        }
    }
}
