#!/bin/bash
sudo apt update
sudo apt upgrade  -y


#java
sudo apt install openjdk-21-jdk  -y
/usr/bin/java –version


#jenkins
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins   -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins


#docker
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -a -G docker $USER
#sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins  
newgrp docker
sudo chmod 777 /var/run/docker.sock


#sonarqube
docker run -d    --name sonar    -p 9000:9000        --restart unless-stopped      sonarqube:latest

# Bilgisayar acildigida Docker'in uzerinde calisan sonarqube containerlarıni otomatik çalıştırma yapmazsak bizzat calistirmak zorunda kaliriz..
# docker ps -a
# docker start SONAR_CONTAINER_ID

#docker run -d
#  --name sonarqube \
#  -p 9000:9000 \
#  --restart unless-stopped \
#  sonarqube:latest


#trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release  -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy  -y


#curl
sudo apt install curl


#aws cli v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install


#kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


#eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
cd /tmp
sudo mv /tmp/eksctl /bin


# EKS nodeları burada kurulu değil.
sudo apt update
sudo apt upgrade -y

#  EKSyi kuracak olan makineye admin rolü vermek lazım.
#  EKSyi de Terraform üzerinden kuruyoruz. En az 1 node gerekli.
#eksctl create cluster --name my-workspace-cluster \
# --region us-east-1 \
# --node-type t3.xlarge \
# --nodes 2


### Helm kurulumu
#curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
#chmod 700 get_helm.sh
#./get_helm.sh
## helm version
#
#helm repo add stable https://charts.helm.sh/stable
#helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#
#kubectl create namespace prometheus
#helm install stable prometheus-community/kube-prometheus-stack -n prometheus
#kubectl get pods -n prometheus

### ArgoCD kurulumu

# makineyi yeniden baslatma en sonda olacak.
 sudo reboot