# DevOps Pipeline

## CI/CD Evreni

```
CI/CD:           (Jenkins, Git,  GitHub, GitOps,  GitHub Actions,    GitLab, GitLab CI,    Bitbucket, Bamboo)
Scripting        (Python, Bash, PowerShell)
Containers:      (Docker)
Orchestration:   (Kubernetes, Helm, ArgoCD)
Cloud            (AWS, Azure, GCP)
Virtualization:  (VMware, VirtualBox)
IaC:             (Terraform, Ansible, CloudFormation)
Monitoring:      (Prometheus, Grafana, ELK)
```


---


IAM -> Users -> mydemouser


AWS'de yeni bir kullanıcı oluşturuyoruz.

Ona Admin yetkisi veriyoruz.


IAM -> Users -> mydemouser -> Create access key

---

Access key
AAAAAAAAAAAAAAAAAAA

Secret access key
BBBBBBBBBBBBBBBBBBBBB

---

Bir terminal aç. Uzaktaki AWS servislerini yönetmek için kullucaya ait Access key ve Secret access key verilerini girdik.

```
aws configure
```

```
AWS Access Key ID : AAAAAAAAAAAAAAAAAAA
AWS Secret Access Key : BBBBBBBBBBBBBBBBBBBBB
Default region name [us-east-1]: us-east-1
Default output format [json]: json
```


Terraform üzerinden de 01_provider.tf dosyasına da bu Access key ve Secret access key verilerini girdik.


#### ReactJS - [Next.js](https://nextjs.org) project [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

```bash
npm run dev
```

http://localhost:3000

---

##  1. Makine: Jenkins Master Node

```bash
aws configure
```


```
java --version
docker --version
jenkins --version
trivy --version
sonar-scanner --version
aws --version
kubectl version 

```

### Docker'da tüm containerları listeledik.
```
docker ps -a
```

```
docker stop CONTAINER_ID
docker start CONTAINER_ID

docker ps -a
```




First, run the development server:

```bash
npm run dev
```
[http://localhost:3000](http://localhost:3000) 