pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT = "vue"
        SLACK_WEBHOOK = credentials('SLACK_WEBHOOK')
        ENV_NAME = "${BRANCH_NAME}"
    }

    stages {
        stage('Deploy') {
            steps {
                script {
                    def PROJECT_DIR = "/var/www/html/${ENV_NAME}/${PROJECT}"

                    sshagent(['jenkins-deploy-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
                            set -e
                            cd ${PROJECT_DIR}
                            echo "Deploying ${PROJECT} → ${ENV_NAME}"

                            git pull origin ${ENV_NAME}
                        if [ "${PROJECT}" = "vue" ] || [ "${PROJECT}" = "next" ]; then
                            npm run build
                            [ "${PROJECT}" = "next" ] && pm2 start npm --name "Next-${ENV_NAME}" -- start && pm2 save
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
