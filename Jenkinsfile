pipeline {
    agent {
        kubernetes {
                    // Define the pod template for checkout
                    yaml '''
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: build-pod
spec:
  serviceAccountName: my-jenkins
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:latest
    args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']

  - name: docker
    image: docker:19.03.12
    command:
    - cat
    tty: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock

  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
'''
        }
    }
    environment {
        // Define repository and image details
        REPO_URL = 'https://github.com/OriTzadok-hub/Elta-Assignment.git'
        IMAGE_REPO = 'oriza/dotnetapp'
        IMAGE_TAG = 'latest'
        DOCKER_IMAGE = "${IMAGE_REPO}:${IMAGE_TAG}"
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
    }

    stages {
        stage('Checkout Code') { 
            steps {
                // Checkout the latest code from the main branch
                git url: REPO_URL, branch: 'main', credentialsId: 'github'
            }
        }
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    script {
                        sh 'dockerd &'
                        sleep 10 // Wait for Docker daemon to start
                        // This will use the credentials securely
                        withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USER --password-stdin'
                        }
                        sh "docker build -t ${DOCKER_IMAGE} -f ./Deployment/DotNetApp/Dockerfile ./Deployment/DotNetApp"
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
        stage('Prepare Environment') {
            steps {
                script {
                    sh '''
                    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
                    chmod +x ./kubectl
                    sh '''
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubeconfig-credentials']) {
                        // Apply Kubernetes manifests to the development namespace
                        sh 'kubectl apply -f Deployment/K8s/deployment.yaml -n dev-namespace'
                        sh 'kubectl apply -f Deployment/K8s/service.yaml -n dev-namespace'
                    }
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

