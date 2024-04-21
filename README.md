# DevOps Assignment - Jenkins CI/CD Pipeline on Kubernetes

## Description
This project automates the setup of a Jenkins instance on Kubernetes and configures it to build and deploy a .NET Core web application. The process is divided into two main steps: building the Jenkins environment and deploying the web application.

### Build Step
1. **Jenkins Setup**: A script is used to create a namespace named `deploy` in the Kubernetes cluster. Subsequently, the Jenkins Helm chart is downloaded and installed in the `devops` namespace.
2. **Configuration**: The Jenkins deployment is upgraded with a `values.yml` file that enables Configuration as Code. This configuration installs necessary plugins, sets up GitHub and DockerHub credentials, and creates a pipeline job linked to a GitHub repository.

### Deployment Step
1. **Build and Push**: A Jenkinsfile defines the pipeline with two main stages. The first stage builds a Docker image from a Dockerfile of the .NET application and pushes it to DockerHub.
2. **Deploy**: The second stage deploys the Docker image as a web application using Kubernetes manifest files (deployment and service). A minor intermediate stage installs `kubectl` on the Jenkins agent.

## Prerequisites
### General
- A Kubernetes cluster with Helm installed.
- A namespace named `devops` created within the cluster.
- Two secrets created within the `devops` namespace:
  1. `github-credentials` for GitHub access.
  2. `dockerhub-credentials` for DockerHub access.

### Deployment
- Manually or via configuration as code, set up `kubeconfig` credentials in Jenkins to allow it to interact with the Kubernetes cluster.

## Configuration Files
- **values.yml**: Contains all configurations used to set up Jenkins plugins, credentials, and the pipeline job.
- **Jenkinsfile**: Defines the pipeline stages for building, pushing, and deploying the .NET application.

## Usage
To deploy this setup:
1. Ensure all prerequisites are met.
2. Run the script to set up Jenkins in the Kubernetes cluster.
3. Verify Jenkins is configured correctly by accessing the Jenkins UI and checking the pipeline job setup.
4. Trigger the pipeline manually or via a GitHub webhook to start the build and deployment process.

## Contributions
Contributions are welcome. Please fork the repository and submit pull requests with your proposed changes.

## License
Specify the license under which this project is made available, such as MIT or Apache 2.0.
