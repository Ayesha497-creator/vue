pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT = "Next"
        ENV_NAME = "${BRANCH_NAME}"         
        // SLACK_WEBHOOK = credentials('SLACK_WEBHOOK')
    }

 stage('SonarQube Analysis') {
    steps {
      
        withSonarQubeEnv('SonarQube-Server') {
           
            sh "${tool 'sonar-scanner'}/bin/sonar-scanner \
                -Dsonar.projectKey=vue-project \
                -Dsonar.sources=."
        }
    }
}
   stage("Quality Gate") {
    steps {
       
        timeout(time: 5, unit: 'MINUTES') {
            waitForQualityGate abortPipeline: true
        }
    }
}

        // --- Stage 2: Deployment ---
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
                                npm run build -- --mode ${ENV_NAME}
                                if [ "${PROJECT}" = "next" ]; then
                                    pm2 restart "Next-${ENV_NAME}"
                                    pm2 save
                                fi
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

    /*
    post {
        success {
            sh """
            curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"✅ ${PROJECT} → ${ENV_NAME} deployed successfully!"}' \
            \$SLACK_WEBHOOK
            """
        }
        failure {
            sh """
            curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"❌ ${PROJECT} → ${ENV_NAME} deployment failed!"}' \
            \$SLACK_WEBHOOK
            """
        }
    }
    */
}
