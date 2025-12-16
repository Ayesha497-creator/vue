pipeline {
    agent any

    environment {
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "13.61.68.173"
        PROJECT = "Next"
        ENV_NAME = "${BRANCH_NAME}"         
        // SLACK_WEBHOOK = credentials('SLACK_WEBHOOK')
    }

    stages {
        // --- Stage 1: SonarQube Scan ---
       stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv('SonarQube-Server') {
            // Hum -e use kar rahe hain taake Jenkins ka Token Docker ke andar chala jaye
            sh "docker run --rm -e SONAR_TOKEN=\$SONAR_AUTH_TOKEN -v \$(pwd):/usr/src sonarsource/sonar-scanner-cli"
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
