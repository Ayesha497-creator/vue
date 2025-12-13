pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        BRANCH_NAME = "development"
        PROJECT = "vue" // yaha default project set kar do, automatic ke liye
    }

    stages {
        stage('Deploy & Build') {
            steps {
                script {
                    def PROJECT_DIR = "/var/www/html/development/${env.PROJECT}"

                    sshagent(['jenkins-deploy-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
                                cd ${PROJECT_DIR} &&
                                echo "Deploying ${env.PROJECT} branch ${BRANCH_NAME}..." &&
                                git pull origin ${BRANCH_NAME} &&

                                if [ -f package.json ]; then
                                    echo "Node.js project detected. Installing dependencies and building..."
                                    npm install
                                    export VUE_APP_BASE_URL="/${env.PROJECT}/"
                                    npm run build
                                fi

                                if [ -f composer.json ]; then
                                    echo "Laravel project detected. Installing dependencies and migrating..."
                                    composer install --no-dev --optimize-autoloader
                                    php artisan migrate --force
                                fi

                                echo "Deployment completed for ${env.PROJECT}!"
                            '
                        """
                    }
                }
            }
        }
    }

    post {
        failure {
            echo "Deployment failed!"
        }
    }
}

