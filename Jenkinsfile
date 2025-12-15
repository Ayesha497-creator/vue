pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT = "vue"
        SLACK_WEBHOOK = credentials('SLACK_WEBHOOK') // Jenkins credential ID use
    }

    stages {
        stage('Deploy') {
            steps {
                script {
                    // Branch name as environment
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
                                npm run build -- --mode ${ENV_NAME}
                            fi

                            if [ "${PROJECT}" = "laravel" ]; then
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
        sh """
        curl -X POST -H 'Content-type: application/json' \
        --data '{"text":"✅ ${PROJECT} → ${ENV_NAME} deployed successfully!"}' \
        $SLACK_WEBHOOK
        """
    }
    failure {
        sh """
        curl -X POST -H 'Content-type: application/json' \
        --data '{"text":"❌ ${PROJECT} → ${ENV_NAME} deployment failed!"}' \
        $SLACK_WEBHOOK
        """
    }
}


    
}
