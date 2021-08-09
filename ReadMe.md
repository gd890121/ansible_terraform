# terraform과 ansible을 이용한 wordpress 배포

- terraform을 이용해 aws를 구성하고 ansible을 이용해 wordpress 배포  


## 1. deploy_wp
- 1개의 ec2에서 wordpress배포와 mysql 구성  
  
  
  
## 2. deploy_wp_ter_RDS
- ec2에서 wordpress를 배포하고 rds를 사용해 database를 구성하고 연동          
                 
## - requirements
### _Install ansible_

```
sudo apt update
sudo apt install -y software-properties-common
sudo apt-add-repository -y -u ppa:ansible/ansible
sudo apt install -y ansible
```
  
    
### _Install terraform_
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform
```
  
### _Install AWS CLIv2 linux_
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip 
sudo ./aws/install
# AWS CLI 구성
aws configure  # aws accesskey, secret key, region 입력
```

# deploy_wp 배포
```
cd deploy_wp
terraform init
ssh-keygen -f my_sshkey -N ''
terraform apply -auto-approve
```

# deploy_wp_ter_RDS 배포
```
cd deplaoy_wp_ter_RDS
terraform init
ssh-keygen -f my_sshkey -N ''
terraform apply -auto-approve
```