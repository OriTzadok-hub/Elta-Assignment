pipeline {
    agent any

    environment {
        // Define repository and image details
        REPO_URL = 'https://github.com/OriTzadok-hub/Elta-Assignment.git'
        IMAGE_REPO = 'oriza/dotnetapp'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the latest code from the master branch
                git url: REPO_URL, branch: 'main', credentialsId: 'github'
            }
        }
        stage('Build and Push Image') {
            steps {
                dir('Deployment/DotNetApp') { // Navigate to the directory containing the Dockerfile
                    script {
                        // Build and push Docker image using tagged latest
                        sh 'docker build -t ${IMAGE_REPO}:${IMAGE_TAG} .'
                        sh 'docker push ${IMAGE_REPO}:${IMAGE_TAG}'
                    }
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
