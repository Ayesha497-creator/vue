pipeline {
    agent any

    parameters {
        choice(name: 'PROJECT', choices: ['vue', 'laravel', 'next'], description: 'Select project to deploy')
    }

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        BRANCH_NAME = "development"
    }

    stages {
        stage('Deploy & Build') {
            steps {
                script {
                    def PROJECT_DIR = "/var/www/html/development/${params.PROJECT}"

                    sshagent(['jenkins-deploy-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
                                cd ${PROJECT_DIR} &&
                                echo "Deploying ${params.PROJECT} branch ${BRANCH_NAME}..." &&
                                git pull origin ${BRANCH_NAME} &&

                                if [ -f package.json ]; then
                                    echo "Node.js project detected. Installing dependencies and building..."
                                    npm install
                                    export VUE_APP_BASE_URL="/${params.PROJECT}/"
                                    npm run build
                                fi

                                if [ -f composer.json ]; then
                                    echo "Laravel project detected. Installing dependencies and migrating..."
                                    composer install --no-dev --optimize-autoloader
                                    php artisan migrate --force
                                fi

                                echo "Deployment completed for ${params.PROJECT}!"
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
