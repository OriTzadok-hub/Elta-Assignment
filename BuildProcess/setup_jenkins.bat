@echo off

:: Create Kubernetes namespaces
kubectl create namespace devops
kubectl create namespace deploy

:: Add Jenkins Helm repository and update
helm repo add jenkins https://charts.jenkins.io
helm repo update

:: Install Jenkins using Helm
helm install my-jenkins jenkins/jenkins --namespace devops

:: Upgrade Jenkins deployment with values.yml
helm upgrade my-jenkins jenkins/jenkins --namespace devops -f values.yml