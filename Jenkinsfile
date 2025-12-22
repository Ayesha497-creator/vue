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
        stage('Quality Gatekeeper (Scan Test)') {
            steps {
                script {
                    env.FAILURE_MSG = "Test Branch Scan"
                    
                    // 1. Automatically test branch checkout karo scan ke liye
                    sh "git fetch origin ${TEST_BRANCH} && git checkout -f ${TEST_BRANCH} && git reset --hard origin/${TEST_BRANCH}"
                    
                    // 2. Scan chalao
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

        stage("Verification & Decision") {
            steps {
                script {
                    env.FAILURE_MSG = "Quality Gate Decision"
                    
                    // 3. Faisla (Decision): Agar status OK nahi hai, toh ye stage fail ho jayegi aur deploy nahi chalega
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "STOPPING DEPLOYMENT: Test branch status is ${qg.status}. Please fix bugs first."
                        }
                    }
                    
                    echo "Quality Gate PASSED. Proceeding to deploy ${ENV_NAME}..."
                }
            }
        }

        stage('Deploy') {
            // Yeh stage sirf tabhi chalegi agar upar wala 'Verification' pass ho gaya
            steps {
                script {
                    env.FAILURE_MSG = "Deployment on ${ENV_NAME}"
                    def PROJECT_DIR = "/var/www/html/${ENV_NAME}/${PROJECT}"
                    
                    // Wapis asli branch par switch karo deployment ke liye
                    sh "git checkout -f ${ENV_NAME} && git pull origin ${ENV_NAME}"
                    
                    sshagent(['jenkins-deploy-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
                            set -e
                            cd ${PROJECT_DIR}
                            git fetch origin ${ENV_NAME} && git reset --hard origin/${ENV_NAME}
                            npm run build -- --mode ${ENV_NAME}
                            [ "${PROJECT}" = "next" ] && pm2 restart "Next-${ENV_NAME}" && pm2 save
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
                // Safety: Fail hone par wapis original branch context set kar do
                sh "git checkout -f ${ENV_NAME}" || echo "Already on branch"
                sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"❌ *${PROJECT}* → *${ENV_NAME}* Deployment Blocked! Failed at: *${env.FAILURE_MSG}*\"}' ${SLACK_WEBHOOK}"
            }
        }
        success {
            sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"✅ *${PROJECT}* → *${ENV_NAME}* Passed Quality Gate & Deployed! 🚀\"}' $SLACK_WEBHOOK"
        }
    }
}
