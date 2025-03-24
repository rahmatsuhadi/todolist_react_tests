pipeline {
    agent any

    tools {
        nodejs 'NodeJS 16' // Sesuaikan dengan nama di Global Tool Configuration
    }

    environment {
        DOCKER_IMAGE = "todo-list-image"  // Ganti dengan nama image Docker
        DOCKER_TAG = "latest"
        CONTAINER_NAME = "app-todo-list"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test -- --watchAll=false --coverage'
                
            }
            post {
                success {
                    // junit 'test-results/jest-junit.xml' // Sesuaikan dengan lokasi file hasil tes
                    echo 'Tests passed successfully!'
                }
                failure {
                    echo 'Tests failed!'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE:$DOCKER_TAG ."
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Menghentikan container lama jika ada..."
                    sh "docker stop $CONTAINER_NAME || true"
                    sh "docker rm $CONTAINER_NAME || true"
                    
                    echo "Menjalankan container baru..."
                    sh """
                    docker run -d --name $CONTAINER_NAME -p 3000:80 $DOCKER_IMAGE:$DOCKER_TAG
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
