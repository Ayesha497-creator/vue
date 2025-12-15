pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT = "vue"
    }

    stages {
        stage('Deploy') {
            steps {
                script {
                    def ENV_NAME = env.BRANCH_NAME
                    def PROJECT_DIR = "/var/www/html/${ENV_NAME}/${PROJECT}"

                    sshagent(['jenkins-deploy-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
                            set -e
                            cd ${PROJECT_DIR}
                            echo "Deploying ${PROJECT} → ${ENV_NAME}"

                            git pull origin ${ENV_NAME}

                            if [ "${PROJECT}" = "vue" ] || [ "${PROJECT}" = "next" ]; then
                                npm install
                                npm run build
                            fi

                            if [ "${PROJECT}" = "laravel" ]; then
                                composer install --no-dev
                                php artisan migrate --force
                            fi
                        '
                        """
                    }
                }
            }
        }
    }
}
