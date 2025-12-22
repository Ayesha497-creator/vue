pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT = "vue"
        ENV_NAME = "${BRANCH_NAME}"         
        TEST_BRANCH = "test" // Benchmark branch
        SLACK_WEBHOOK = credentials('SLACK_WEBHOOK')
    }

    stages {
        stage('SonarQube Analysis') {
            steps {
                script { 
                    env.FAILURE_MSG = STAGE_NAME 
                    
                    // --- Gatekeeper Logic Start ---
                    // Pehle sirf scan ke liye test branch ka code fetch karke checkout karo
                    sh "git fetch origin ${TEST_BRANCH}"
                    sh "git checkout ${TEST_BRANCH}"
                    // --- Gatekeeper Logic End ---

                    withSonarQubeEnv('SonarQube-Server') {
                        sh """
                        export NODE_OPTIONS="--max-old-space-size=4096"
                        ${tool 'sonar-scanner'}/bin/sonar-scanner \
                            -Dsonar.projectKey=${PROJECT}-project \
                            -Dsonar.sources=. \
                            -Dsonar.javascript.node.maxspace=4096 \
                            -Dsonar.exclusions=**/node_modules/**,**/vendor/**,**/public/packages/**
                        """
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    env.FAILURE_MSG = STAGE_NAME 
                    try {
                        timeout(time: 1, unit: 'HOURS') {
                            def qg = waitForQualityGate()
                            if (qg.status != 'OK') {
                                error "Quality Gate Failed"
                            }
                        }
                    } catch (e) {
                        env.FAILURE_MSG = "Quality Gate Failed"
                        error "Quality Gate Failed"
                    } finally {
                        // Scan ho gaya, ab wapis apni asli branch par switch karo
                        sh "git checkout ${ENV_NAME}"
                    }
                }
            }
        }

        stage('Deploy') {
            // Ye stage tabhi chalegi jab Quality Gate 'OK' hoga
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
                            echo "Starting Deployment for ${PROJECT} on ${ENV_NAME}..."

                            git fetch origin ${ENV_NAME}

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
        success {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"✅ *${PROJECT}* → *${ENV_NAME}* Deployed Successfully! 🚀\"}' $SLACK_WEBHOOK"
        }
        failure {
            script {
                def finalStage = env.FAILURE_MSG ?: "Initial Setup"
                sh """
                curl -X POST -H 'Content-type: application/json' \
                --data '{"text":"❌ *${PROJECT}* → *${ENV_NAME}* Failed at: *${finalStage}*"}' \
                ${SLACK_WEBHOOK}
                """
            }
        }
    }
}
