pipeline {
    agent {
        kubernetes {
            // Define the pod template
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: kaniko
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    args: ["--dockerfile=Deployment/DotNetApp/Dockerfile",
           "--context=dir://$$(WORKSPACE)/Deployment/DotNetApp",
           "--destination=oriza/dotnetapp:latest"]
    volumeMounts:
    - name: kaniko-secret
      mountPath: /kaniko/.docker
  restartPolicy: Never
  volumes:
  - name: kaniko-secret
    secret:
      secretName: reg-credentials
            """
        }
    }

    environment {
        // Define repository and image details
        REPO_URL = 'https://github.com/OriTzadok-hub/Elta-Assignment.git'
        IMAGE_REPO = 'oriza/dotnetapp'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the latest code from the main branch
                git url: REPO_URL, branch: 'main', credentialsId: 'github'
            }
        }
        stage('Build and Push Image') {
            steps {
                // Kaniko executes build and push in one step
                container('kaniko') {
                    sh 'echo Building and pushing Docker Image'
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
