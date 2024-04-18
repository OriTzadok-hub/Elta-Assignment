pipeline {
    agent any

    environment {
        // Define repository and image details
        REPO_URL = 'https://github.com/OriTzadok-hub/Elta-Assignment.git'
        IMAGE_NAME = 'oriza/dotnetapp'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the latest code from the main branch
                git url: REPO_URL, branch: 'main', credentialsId: 'github'
            }
        }
        stage('Build image') {
          steps{
            script {
              dockerImage = docker.build(IMAGE_NAME, 'Deployment/DotNetApp' -f 'Deployment/DotNetApp/Dockerfile')
            }
          }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply Kubernetes manifests to the development namespace
                    sh 'kubectl apply -f Deployment/K8s/deployment.yaml -n dev-namespace'
                    sh 'kubectl apply -f Deployment/K8s/service.yaml -n dev-namespace'
                }
            }
        }
    }

    post {
        always {
            // Cleanup after the build
            cleanWs()
        }
    }
}
