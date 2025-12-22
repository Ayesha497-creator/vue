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
                    
                    // Branch switching for scanning
                    sh "git fetch origin ${TEST_BRANCH}"
                    sh "git checkout -f ${TEST_BRANCH}"
                    sh "git reset --hard origin/${TEST_BRANCH}"

                    // withSonarQubeEnv ke andar hi scanner chalana zaroori hai
                    withSonarQubeEnv('SonarQube-Server') {
                        sh """
                        export NODE_OPTIONS="--max-old-space-size=2048"
                        ${tool 'sonar-scanner'}/bin/sonar-scanner \
                            -Dsonar.projectKey=${PROJECT}-project \
                            -Dsonar.sources=. \
                            -Dsonar.javascript.node.maxspace=2048 \
                            -Dsonar.exclusions=**/node_modules/**,**/vendor/** \
                            -Dsonar.projectVersion=${BUILD_NUMBER}
                        """
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    env.FAILURE_MSG = STAGE_NAME 
                    // 10 second ka gap taake SonarQube task register kar le
                    sleep 10
                    
                    timeout(time: 1, unit: 'HOURS') {
                        // waitForQualityGate ko manually task result milna chahiye
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Quality Gate Failed: ${qg.status}"
                        }
                    }
                    
                    // Scan pass hone par wapis original branch par switch karein
                    sh "git checkout -f ${ENV_NAME}"
                }
            }
        }

        stage('Deploy') {
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
        success {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"✅ *${PROJECT}* → *${ENV_NAME}* Deployed Successfully! 🚀\"}' $SLACK_WEBHOOK"
        }
        failure {
            script {
                def finalStage = env.FAILURE_MSG ?: "Initial Setup"
                sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"❌ *${PROJECT}* → *${ENV_NAME}* Failed at: *${finalStage}*\"}' ${SLACK_WEBHOOK}"
            }
        }
    }
}
