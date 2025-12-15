pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT = "vue"
        // SLACK_WEBHOOK = "https://hooks.slack.com/services/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"
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
                              
                               npm run build 
                            fi

                            if [ "${PROJECT}" = "laravel" ]; then
                                php artisan optimize
                                echo "Laravel build completed"
                            fi
                        '
                        """
                    }
                }
            }
        }
    }
    // post {
    //     success {
    //         sh '''
    //         curl -s -X POST -H "Content-type: application/json" \
    //         --data '{
    //             "text": "✅ Deployment SUCCESS\nProject: '"${PROJECT}"'\nBranch: '"${ENV_NAME}"'"
    //         }' \
    //         '"${SLACK_WEBHOOK}"' || true
    //         '''
    //     }

    //     failure {
    //         sh '''
    //         curl -s -X POST -H "Content-type: application/json" \
    //         --data '{
    //             "text": "❌ Deployment FAILED\nProject: '"${PROJECT}"'\nBranch: '"${ENV_NAME}"'"
    //         }' \
    //         '"${SLACK_WEBHOOK}"' || true
    //         '''
    //     }
    // }
}
