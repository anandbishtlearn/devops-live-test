pipeline {
    agent any
    environment {
        IMAGE_NAME = 'bluegreen-web'
        GREEN_PORT = '8081'
        BLUE_PORT = '8082'
        NGINX_CONF = '/etc/nginx/sites-available/default'
    }
    stages {
        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        stage('Deploy') {
            steps {
                script {
                    def greenRunning = sh(script: "docker ps -q --filter 'name=green'", returnStdout: true).trim()
                    if (greenRunning) {
                        echo "Green is running, deploying to Blue"
                        sh """
                            docker stop blue || true
                            docker rm blue || true
                            docker run -d --name blue -p ${BLUE_PORT}:80 $IMAGE_NAME
                            sudo sed -i 's|proxy_pass http://localhost:[0-9]*;|proxy_pass http://localhost:${BLUE_PORT};|' $NGINX_CONF
                            sudo systemctl reload nginx
                        """
                    } else {
                        echo "Blue is running or first deployment, deploying to Green"
                        sh """
                            docker stop green || true
                            docker rm green || true
                            docker run -d --name green -p ${GREEN_PORT}:80 $IMAGE_NAME
                            sudo sed -i 's|proxy_pass http://localhost:[0-9]*;|proxy_pass http://localhost:${GREEN_PORT};|' $NGINX_CONF
                            sudo systemctl reload nginx
                        """
                    }
                }
            }
        }
    }
}
