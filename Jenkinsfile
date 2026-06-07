pipeline {
    agent any

    tools {
        nodejs 'NodeJS24'
    }

    environment {
        APP_NAME = "devops-05-terraform-aws-pipeline"
        RELEASE = "1.0.${env.BUILD_NUMBER}"
        DOCKER_USER = "taskin87"
        DOCKER_PASS = 'TokenDockerHubForJenkins'
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG  = "${RELEASE}"
        SCANNER_HOME = tool "sonar-scanner"
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('SCM GitHub') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/yuzelt/devops-05-terraform-aws-pipeline']])
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    if (isUnix()) { // Linux veya MacOS bir ortamda çalışıyorsanız, sh komutunu kullanarak npm install yapabilirsiniz
                        sh "npm install"
                    } else {
                        bat "npm install" // Windows ortamında çalışıyorsanız, bat komutunu kullanarak npm install yapabilirsiniz
                    }
                }
            }
        }

        stage('SonarQube Scan') {
            steps {
                script {
                    def scannerHome = tool 'sonar-scanner'
                    withSonarQubeEnv('SonarTokenForJenkins') {
                        sh """
                        ${scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=devops-05-terraform-aws-pipeline \
                        -Dsonar.projectName=devops-05-terraform-aws-pipeline
                        """
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarTokenForJenkins'
                }
            }
        }

        stage("Trivy FS Scan") {
            steps {
                script {
                    sh "trivy fs . > trivyfs.txt"
                }
            }
        }

        stage('Docker Image Clean') {
            steps {
                script {
                    if (isUnix()) {
                        sh "docker image prune -f"
                    } else {
                        bat "docker image prune -f"
                    }
                }
            }
        }

        stage("Docker Build & Push") {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'TokenDockerHubForJenkins', toolName: 'docker') {
                        sh "docker build -t devops-05-terraform-aws-pipeline:latest ."
                        sh "docker tag devops-05-terraform-aws-pipeline:latest taskin87/devops-05-terraform-aws-pipeline:latest"
                        sh "docker push taskin87/devops-05-terraform-aws-pipeline:latest"
                    }
                }
            }
        }

        stage("Trivy Image Scan") {
            steps {
                sh "trivy image taskin87/devops-05-terraform-aws-pipeline:latest > trivyimage.txt"
            }
        }

        /*
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    dir('kubernetes') {
                        withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'kubernetes', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                            sh 'kubectl delete --all pods'
                            sh 'kubectl apply -f deployment.yml'
                            sh 'kubectl apply -f service.yml'
                        }
                    }
                }
            }
        }
        */

    }

    post {
        always {
            emailext attachLog: true,
                subject: "'${currentBuild.result}'",
                body: "Project: ${env.JOB_NAME}<br/>" +
                    "Build Number: ${env.BUILD_NUMBER}<br/>" +
                    "URL: ${env.BUILD_URL}<br/>",
                to: 'taskinyuz@gmail.com',
                attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
        }
    }

}
