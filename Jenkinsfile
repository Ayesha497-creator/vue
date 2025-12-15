pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        BRANCH_NAME = "development"
        PROJECT = "vue"
        SLACK_WEBHOOK = "https://hooks.slack.com/services/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"
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
                            echo "Deploying ${PROJECT}..." &&
                            git pull origin ${BRANCH_NAME}

                            if [ -f package.json ]; then
                                echo "Node project (Vue / Next) detected"
                                rm -rf dist
                                npm run build
                            fi

                            if [ -f composer.json ]; then
                                echo "Laravel project detected"
                                composer install --no-dev --optimize-autoloader
                                php artisan migrate --force
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
        sh '''
        curl -s -X POST -H "Content-type: application/json" \
        --data '{
            "text": "✅ Deployment SUCCESS\nProject: '"${PROJECT}"'\nBranch: '"${BRANCH_NAME}"'"
        }' \
        '"${SLACK_WEBHOOK}"' || true
        '''
    }

    failure {
        sh '''
        curl -s -X POST -H "Content-type: application/json" \
        --data '{
            "text": "❌ Deployment FAILED\nProject: '"${PROJECT}"'\nBranch: '"${BRANCH_NAME}"'"
        }' \
        '"${SLACK_WEBHOOK}"' || true
        '''
    }
}

