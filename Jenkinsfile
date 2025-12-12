pipeline {
    agent any

    tools {
        nodejs 'nodejs'
    }

    environment {
        PROJECT_DIR = "${WORKSPACE}"
        BASE_DEPLOY_DIR = "/var/www/html"
        // Slack webhook skipped
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${BRANCH_NAME}",
                    url: 'https://github.com/Ayesha497-creator/vue.git'
            }
        }

        stage('Build Vue') {
            steps {
                dir("${PROJECT_DIR}") {
                    echo "Installing dependencies..."
                    sh 'npm install'

                    echo "Building Vue project..."
                    sh 'npm run build'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def DEPLOY_DIR = "${BASE_DEPLOY_DIR}/${BRANCH_NAME}/vue"

                    sh """
                        sudo mkdir -p ${DEPLOY_DIR}
                        sudo cp -r ${PROJECT_DIR}/dist/* ${DEPLOY_DIR}/
                        sudo chown -R www-data:www-data ${DEPLOY_DIR}
                    """
                    echo "✅ Branch ${BRANCH_NAME} deployed to ${DEPLOY_DIR}"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful for branch: ${BRANCH_NAME}"
        }

        failure {
            echo "❌ Deployment Failed for branch: ${BRANCH_NAME}"
        }
    }
}
