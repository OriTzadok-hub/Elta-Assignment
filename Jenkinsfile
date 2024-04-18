pipeline {
    agent {
        kubernetes {
            // Define the pod template
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
    image: jenkins/inbound-agent:4.3-4
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
                        sh "docker build -t ${DOCKER_IMAGE} ."
                        sh "docker push ${DOCKER_IMAGE}"
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
