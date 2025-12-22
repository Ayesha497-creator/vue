pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT = "vue"
        ENV_NAME = "${BRANCH_NAME}"         
        TEST_BRANCH = "test" 
        SLACK_WEBHOOK = credentials('SLACK_WEBHOOK')
    }

    stages {
        stage('SonarQube Analysis') {
            steps {
                script { 
                    env.FAILURE_MSG = STAGE_NAME 
                    
                    // 1. Pehle Test Branch ko fetch aur checkout karo (Scan ke liye)
                    sh "git fetch origin ${TEST_BRANCH}"
                    sh "git checkout -f ${TEST_BRANCH}"
                    sh "git reset --hard origin/${TEST_BRANCH}"
                    
                    // Debug: Check karein ke commit ID 4b5a439... hi hai na
                    sh "git log -1 --format='%H'"

                    // 2. Scan chalao (Ye TEST_BRANCH ka code scan karega)
                    withSonarQubeEnv('SonarQube-Server') {
                        sh """
                        export NODE_OPTIONS="--max-old-space-size=2048"
                        ${tool 'sonar-scanner'}/bin/sonar-scanner \
                            -Dsonar.projectKey=${PROJECT}-project \
                            -Dsonar.sources=. \
                            -Dsonar.exclusions=**/node_modules/**,**/vendor/**
                        """
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    env.FAILURE_MSG = STAGE_NAME 
                    // Yahan hum TEST_BRANCH par hi rukay hue hain jab tak result nahi aata
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Quality Gate Failed on Test Branch: ${qg.status}"
                        }
                    }
                    
                    // AGAR PASS HUA: Toh ab wapis Current Branch (e.g. development) par switch karo
                    echo "Quality Gate Passed! Switching back to ${ENV_NAME} for deployment."
                    sh "git checkout -f ${ENV_NAME}"
                    sh "git pull origin ${ENV_NAME}"
                }
            }
        }

        stage('Deploy') {
            // Ye tabhi chalega jab Quality Gate 'OK' ho chuka hoga aur branch switch ho gayi hogi
            when { expression { return currentBuild.result == null || currentBuild.result == 'SUCCESS' } }
            steps {
                script {
                    env.FAILURE_MSG = STAGE_NAME
                    def PROJECT_DIR = "/var/www/html/${ENV_NAME}/${PROJECT}"
                    sshagent(['jenkins-deploy-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
                            set -e
                            cd ${PROJECT_DIR}
                            git fetch origin ${ENV_NAME}
                            git reset --hard origin/${ENV_NAME}

                            if [ "${PROJECT}" = "vue" ] || [ "${PROJECT}" = "next" ]; then
                                npm run build -- --mode ${ENV_NAME}
                                if [ "${PROJECT}" = "next" ]; then
                                    pm2 restart "Next-${ENV_NAME}" 
                                    pm2 save
                                fi
                            elif [ "${PROJECT}" = "laravel" ]; then
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
            script {
                // Agar fail ho jaye toh bhi safety ke liye development par wapis le aao
                sh "git checkout -f ${ENV_NAME}" || echo "Already on branch or failed to switch"
                def finalStage = env.FAILURE_MSG ?: "Initial Setup"
                sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"❌ *${PROJECT}* → *${ENV_NAME}* Failed at: *${finalStage}*\"}' ${SLACK_WEBHOOK}"
            }
        }
        success {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"✅ *${PROJECT}* → *${ENV_NAME}* Deployed Successfully! 🚀\"}' $SLACK_WEBHOOK"
        }
    }
}
