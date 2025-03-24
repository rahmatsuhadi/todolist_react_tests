pipeline {
    agent any

    triggers {
        pollSCM('H/1 * * * *')  // Memeriksa perubahan setiap 1 menit
    }
    environment{
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
        stage('Install Dependencies && Run Tests') {
            steps {
                script {
                    sh 'npm install'
                    echo 'Install Library yang diperluan....'
                    // testing aplikasi
                    echo "menjalankan test pada code program untuk pengetesan...."
                    sh 'npm test -- --watchAll=false'
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Melakukan build image docker....'
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
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
                    docker run -d --name $CONTAINER_NAME -p 3000:3000 $DOCKER_IMAGE:$DOCKER_TAG
                    """
                }
            }
        }
    }
}