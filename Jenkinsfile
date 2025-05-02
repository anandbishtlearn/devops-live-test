pipeline {
    agent any
    environment {
        IMAGE_NAME = 'bluegreen-web'
        GREEN_PORT = '8081'
        BLUE_PORT = '8082'
    }
    stages {
            stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        stage('Deploy Green') {
            steps {
                script {
                    def running = sh(script: "docker ps -q --filter 'name=green'", returnStdout: true).trim()
                    if (running) {
                        echo "Green already running, switching to Blue"
                        sh '''
                            docker stop blue || true
                            docker rm blue || true
                            docker run -d --name blue -p ${BLUE_PORT}:80 $IMAGE_NAME
                            sudo sed -i 's/PORT/8082/' /etc/nginx/sites-available/default
                            sudo systemctl reload nginx
                        '''
                    } else {
                        echo "Deploying to Green"
                        sh '''
                            docker stop green || true
                            docker rm green || true
                            docker run -d --name green -p ${GREEN_PORT}:80 $IMAGE_NAME
                            sudo sed -i 's/PORT/8081/' /etc/nginx/sites-available/default
                            sudo systemctl reload nginx
                        '''
                    }
                }
            }
        }
    }
}
