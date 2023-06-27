locals {
  ansible_user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt-add-repository ppa:ansible/ansible
sudo apt update -y
sudo apt install ansible -y
sudo hostnamectl set-hostname ansible
sudo apt install python3-pip -y
ansible-galaxy collection install amazon.aws
pip install boto3
sudo apt install docker.io -y
sudo mkdir /opt/docker
sudo chown -R ubuntu:ubuntu /opt/docker
sudo chmod -R 700 /opt/docker
sudo apt install unzip -y
sudo apt install curl -y
curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip
sudo cp newrelic-java.zip /opt/docker
sudo unzip /opt/docker/newrelic-java.zip -d /opt/docker
sudo rm newrelic-java.zip
sudo chmod -R 700 /home/ubuntu/.ssh
sudo chmod 700 /home/ubuntu/.ssh/authorized_keys
sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh
sudo bash -c ' echo "StrictHostKeyChecking No" >> /etc/ssh/ssh_config'
echo "${var.tls_private_key}" >> /home/ubuntu/.ssh/anskey_rsa
sudo chmod 400 anskey_rsa
cat <<EOT>> /etc/ansible/hosts
localhost ansible_connection=local
[docker_stage]
${var.docker-stage-ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/anskey_rsa
[docker_prod]
${var.docker-prod-ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/anskey_rsa
EOT
sudo echo "*/20 * * * * ubuntu ansible-playbook -i /etc/ansible/hosts /opt/docker/get-newIP.yaml" > /etc/crontab

touch /opt/docker/Dockerfile
cat <<EOT>> /opt/docker/Dockerfile
FROM openjdk
COPY spring-petclinic-2.4.2.war app/
COPY ./newrelic/newrelic.jar  app/
COPY ./newrelic/newrelic.yml  app/ 
ENV NEW_RELIC_APP_NAME="lington-application"
ENV NEW_RELIC_LICENSE_KEY="eu01xx824af7624c2e9de117fe224214d200NRAL"
ENV NEW_RELIC_LOG_FILE_NAME="STDOUT"
ENTRYPOINT ["java","-javaagent:/app/newrelic.jar","-jar","/app/spring-petclinic-2.4.2.war", "--server.port=8085"] 
EOT

touch /opt/docker/docker_image.yaml
cat <<EOT>> /opt/docker/docker_image.yaml
---
 - name: ansible playbook for docker image
   hosts: localhost
   become: true

   tasks:
   - name: login  to our docker hub account
     command: docker login --username=lington --password=@Darboy123
     

   - name: create/build docker image from our Dockerfile   
     command: docker build -t super-docker-image .
     args:
      chdir: /opt/docker

   - name: create docker tag before we push our image to docker hub
     command: docker tag super-docker-image lington/super-docker-image

   - name: push to docker hub
     command: docker push lington/super-docker-image

   - name: remove docker image after pushing
     command: docker rmi lington/super-docker-image super-docker-image
     ignore_errors: yes
EOT

touch /opt/docker/docker_stage.yaml
cat <<EOT>> /opt/docker/docker_stage.yaml
---
 - name: this is a ansible playbook for docker stage for testing
   hosts: docker_stage
   become: true

   tasks:
   - name: login  to our docker hub account
     command: docker login --username=lington --password=@Darboy123
    
   
   - name: lets assume that our container is already running so we need to stop it
     command: docker stop test-docker-container
     ignore_errors: yes

   - name: remove docker stopped docker container
     command: docker rm test-docker-container
     ignore_errors: yes

   - name: remove the docker image after pushing
     command: docker rmi lington/super-docker-image lington-docker-image
     ignore_errors: yes

   - name: pull docker image from docker hub account
     command: docker pull lington/super-docker-image

   - name: Create docker container for stage from the image we pulled from dockerhub
     command: docker run -itd  --name test-docker-container -p 8080:8085 lington/super-docker-image
EOT

touch /opt/docker/docker_prod.yaml
cat <<EOT>> /opt/docker/docker_prod.yaml
---
 - name: this is a ansible playbook for docker prod for production environment
   hosts: docker_prod
   become: true

   tasks:
   - name: login  to our docker hub account
     command: docker login --username=lington --password=@Darboy123
     
   
   - name: lets assume that our container is already running so we need to stop it
     command: docker stop test-docker-container
     ignore_errors: yes

   - name: remove docker stopped docker container
     command: docker rm test-docker-container
     ignore_errors: yes

   - name: remove the docker image after pushing
     command: docker rmi lington/super-docker-image lington-docker-image
     ignore_errors: yes

   - name: pull docker image from docker hub account
     command: docker pull lington/super-docker-image

   - name: Create docker container for stage from the image we pulled from dockerhub
     command: docker run -itd  --name test-docker-container -p 8080:8085 lington/super-docker-image
EOT

cat <<EOT>> /opt/docker/get-newIP.yaml
---
 - name: sending ip created from ASG to ansible inventory file and also saving the docker stage and prod ip address in a new file
   hosts: localhost
   connection: local
   user: ubuntu

   
   tasks:
   - name: Get IP Address in the Inventory host file /etc/ansible/hosts ie docker_stage & docker_prod
     set_fact: 
       stage="{{groups['docker_stage'] | join(',')}}"
       prod="{{groups['docker_prod'] | join(',')}}"

   - name: store docker prod and stage inventory file in another file /opt/docker/oldStageIp.yaml & /opt/docker/oldProdIp.yaml
     shell:
       echo "{{stage}}" ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/anskey_rsa >  /opt/docker/oldStageIp.yaml
       echo "{{prod}}" ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/anskey_rsa >  /opt/docker/oldProdIp.yaml

   - name: getting list of new instances created by ASG
     amazon.aws.ec2_instance_info: 
       region: eu-west-2 
       filters: 
         "tag:Name": ["docker-prod-ASG"]  
     register: ec2_instance_info

   - set_fact:
       msg: "{{ec2_instance_info | json_query('instances[*].private_ip_address')}}"
   - debug:
       var: msg
     register: ec2_privateIP     

   - name: store new ec2 IP created by ASG in a new file
     shell: |
       echo "{{msg}}" > /opt/docker/docker-prod-ASGIP.yaml  

   - name: update the new ec2 IP created from ASG in the Inventory file
     become: yes
     shell: |
        echo "[docker-prod-ASG]" > /etc/ansible/hosts;
        {% for ip in range(ec2_privateIP['msg']|length)%}
        echo "{{ec2_privateIP['msg'][ip]}} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/anskey_rsa" >> /etc/ansible/hosts
        {%endfor%}
        echo "[docker_stage]" >> /etc/ansible/hosts
        cat /opt/docker/oldStageIp.yaml >> /etc/ansible/hosts
        echo "[docker_prod]" >> /etc/ansible/hosts
        cat /opt/docker/oldProdIp.yaml >> /etc/ansible/hosts

   - name: echo
     shell: |
       echo "New ip Address in Inventory File"
       echo " Ready to deploy App to new Ip" 

   - name: Deploying Applications to new ASG Servers
     shell: |
       ansible-playbook -i /etc/ansible/hosts /opt/docker/deploy-newIP.yaml  
     register: deploying

   - debug: 
         msg:  "{{deploying.stdout}}"
EOT

cat <<EOT>> /opt/docker/deploy-newIP.yaml
---
 - name: this is a ansible playbook for docker prod for production environment
   hosts: docker-prod-ASG
   become: true

   tasks:
   - name: login  to our docker hub account
     command: docker login --username=lington --password=@Darboy123
     
   
   - name: lets assume that our container is already running so we need to stop it
     command: docker stop test-docker-container
     ignore_errors: yes

   - name: remove docker stopped docker container
     command: docker rm test-docker-container
     ignore_errors: yes

   - name: remove the docker image after pushing
     command: docker rmi lington/super-docker-image lington-docker-image
     ignore_errors: yes

   - name: pull docker image from docker hub account
     command: docker pull lington/super-docker-image
     ignore_errors: yes

   - name: Create docker container for stage from the image we pulled from dockerhub
     command: docker run -itd  --name test-docker-container -p 8080:8085 lington/super-docker-image
     ignore_errors: yes
EOT
EOF
}