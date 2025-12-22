pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT     = "vue" // Isko aap laravel ya next bhi kar sakti hain
        ENV_NAME    = "${BRANCH_NAME}"         
        TEST_BRANCH = "test" 
        SLACK_WEBHOOK = credentials('SLACK_WEBHOOK')
    }

    stages {
        stage('Quality Gatekeeper (Scan Test Branch)') {
            steps {
                script {
                    env.FAILURE_MSG = "Quality Gatekeeper"
                    
                    try {
                        sh "git fetch origin ${TEST_BRANCH} && git checkout -f ${TEST_BRANCH} && git reset --hard origin/${TEST_BRANCH}"
                        
                        withSonarQubeEnv('SonarQube-Server') {
                            sh """
                            export NODE_OPTIONS="--max-old-space-size=2048"
                            ${tool 'sonar-scanner'}/bin/sonar-scanner \
                                -Dsonar.projectKey=${PROJECT}-project \
                                -Dsonar.sources=. \
                                -Dsonar.exclusions=**/node_modules/**,**/vendor/**
                            """
                        }

                        timeout(time: 1, unit: 'HOURS') {
                            def qg = waitForQualityGate()
                            if (qg.status != 'OK') {
                                error "STOPPING DEPLOYMENT: Test code failed Quality Gate with status: ${qg.status}"
                            }
                        }
                        echo "Verification Passed! Preparing for deployment."

                    } finally {
                        // Scan pass ho ya fail, workspace ko wapis asli branch par le aao
                        sh "git checkout -f ${ENV_NAME} && git pull origin ${ENV_NAME}"
                    }
                }
            }
        }

        stage('Deploy to Server') {
            when { 
                allOf {
                    expression { return ENV_NAME != TEST_BRANCH }
                    expression { return currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                }
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
                            git fetch origin ${ENV_NAME} && git reset --hard origin/${ENV_NAME}

                            # PROJECT WISE LOGIC
                            if [ "${PROJECT}" = "vue" ] || [ "${PROJECT}" = "next" ]; then
                                npm run build -- --mode ${ENV_NAME}
                                if [ "${PROJECT}" = "next" ]; then
                                    pm2 restart "Next-${ENV_NAME}" || pm2 start npm --name "Next-${ENV_NAME}" -- run start
                                    pm2 save
                                fi
                            elif [ "${PROJECT}" = "laravel" ]; then
                                composer install --no-interaction --prefer-dist --optimize-autoloader
                                php artisan optimize
                            fi
                        '
                        """
                    }
                }
            }
        }
    }

    post {
        failure {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"❌ *${PROJECT}* → *${ENV_NAME}* Deployment Blocked!\\nFailed at: *${env.FAILURE_MSG}*\"}' ${SLACK_WEBHOOK}"
        }
        success {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"✅ *${PROJECT}* → *${ENV_NAME}* Passed Quality Gate & Deployed Successfully! 🚀\"}' $SLACK_WEBHOOK"
        }
    }
}
