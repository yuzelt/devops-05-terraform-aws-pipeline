pipeline {
     agent any

    tools {
        nodejs 'NodeJS24'
    }

    environment {
          APP_NAME = "devops-05-terraform-aws-pipeline"
          RELEASE = "1.0.${env.BUILD_NUMBER}"
          DOCKER_USER = "mimaraslan"
          DOCKER_PASS = 'ID_TOKEN_DOCKER'
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
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/mimaraslan/devops-05-terraform-aws-pipeline']])
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    if (isUnix()) {  // Linux veya MacOS bir ortamda çalışıyorsanız, sh komutunu kullanarak npm install yapabilirsiniz
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



/*
        stage('Docker Image') {
            steps {
                 script {
                    if (isUnix()) {
                        sh 'docker build  -t  mimaraslan/devops-05-terraform-aws-pipeline:latest  .'
                    } else {
                        bat 'docker build  -t  mimaraslan/devops-05-terraform-aws-pipeline:latest  .'
                    }
                }
            }
        }
*/

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
                        //  sh "docker system prune -af || true"
                    } else {
                        bat "docker image prune -f"
                      //  bat "docker system prune -af || true"
                    }
                }
            }
        }


         stage("Docker Build & Push"){
             steps{
                 script{
                   withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker'){
                      sh "docker build  -t  devops-05-terraform-aws-pipeline:latest . "
                      sh "docker tag devops-05-terraform-aws-pipeline mimaraslan/devops-05-terraform-aws-pipeline:latest "
                      sh "docker push mimaraslan/devops-05-terraform-aws-pipeline:latest "
                    }
                }
            }
        }



// ÖDEV uyarlanacak.
/*
    stage('Docker Build Image & Push DockerHub') {
            steps {
                 script {
                     docker.withRegistry('', DOCKER_PASS) {
                         myDockerImage  =  docker.build "${IMAGE_NAME}"
                         myDockerImage.push("${IMAGE_TAG}")
                         myDockerImage.push("latest")
                     }
                }
            }
        }
*/


        stage("Trivy Image Scan"){
            steps{
                sh "trivy image devops-05-terraform-aws-pipeline:latest > trivyimage.txt"
            }
        }



/*

        stage('DockerHub') {
            steps {
                echo "Image DockerHub'a gönder."
                 script {
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {


                            if (isUnix()) {
                             //   sh 'docker login    -u mimaraslan     -p   %dockerhub%'
                                sh 'docker push mimaraslan/devops-application:latest'
                            } else {
                             //    bat 'docker login    -u mimaraslan     -p   %dockerhub%'
                                 bat 'docker push mimaraslan/devops-application:latest'
                            }
                        }
                 }

            }
        }
*/


// ODEV
/*
   stage('Docker DockerHub') {
            steps {
                 script {
                     docker.withRegistry('', DOCKER_PASS) {
                         docker.build(IMAGE_TAG)
                     }
                }
            }
        }
*/



/*
        stage('Kubernetes (K8s)') {
            steps {
                 script {
                      kubernetesDeploy (configs: 'deployment-service.yml',  kubeconfigId: 'kubernetes')
                     echo "K8s içinde image'ı çalıştır."
                 }

            }
        }
 */




/*
        stage('Deploy to Kubernetes'){
            steps{
                script{
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




/*

        stage('Cleanup Old Docker Images') {
            steps {
                script {
                    if (isUnix()) {
                        // Bu repo için tüm image’leri al, tarihe göre sırala, son 3 hariç sil
                        sh """
                            docker images "${env.IMAGE_NAME}" --format "{{.Repository}}:{{.Tag}} {{.CreatedAt}}" \\
                            | sort -r -k2 \\
                            | tail -n +4 \\
                            | awk '{print \$1}' \\
                            | xargs -r docker rmi -f
                        """

                    } else {
                        bat """
                             for /f "skip=3 tokens=1" %%i in ('docker images ${env.IMAGE_NAME} --format "{{.Repository}}:{{.Tag}}" ^| sort') do docker rmi -f %%i
                        """
                    }
                }
            }
        }



        stage("Trigger GitOps ArgoCD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user mimaraslan:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-100-49-167-117.compute-1.amazonaws.com:8080/job/devops_004_pipeline_gitops/buildWithParameters?token=GITOPS_TRIGGER_START'"
                }
            }
        }

*/

/*
        stage('Clean to Trivy Cache') {
            steps {
                sh '''
                echo "Cleaning Trivy cache..."
                trivy clean --all || true
                '''
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
            to: 'YOUR_MAIL@gmail.com',
            attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
        }
    }



}