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
        stage('Deploy') {
            steps {
                script {
                    // Set remote project directory based on selected project
                    def PROJECT_DIR = "/var/www/html/development/${params.PROJECT}"

                    sshagent(['jenkins-deploy-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
                                cd ${PROJECT_DIR} &&
                                echo "Deploying ${params.PROJECT} branch ${BRANCH_NAME}..." &&
                                git pull origin ${BRANCH_NAME} &&
                                # Build based on project type
                                if [ -f package.json ]; then
                                    echo "Node.js project detected. Installing and building..."
                                    npm install
                                    npm run build
                                fi
                                if [ -f composer.json ]; then
                                    echo "Laravel project detected. Installing dependencies..."
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

        // stage('Notify Slack') {
        //     steps {
        //         script {
        //             sh """
        //                 curl -X POST -H 'Content-type: application/json' \
        //                 --data '{\"text\":\"Deployment of ${params.PROJECT} branch ${BRANCH_NAME} successful!\"}' \
        //                 ${SLACK_WEBHOOK}
        //             """
        //         }
        //     }
        // }
    }

    post {
        failure {
            echo "Deployment failed!"
            // Slack notification for failure can go here
        }
    }
}
