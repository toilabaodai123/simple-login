# About
This project is mainly about practicing with infrastructure.
## Tools, other technologies used in this project
- **Docker**  
    Build container image for the Laravel web application.  
    Serve the container image from above on a AWS EC2 instance.  
- **AWS**  
    EC2:  For a webservice using a Docker container to handle requests  
    ~~S3:  Store backups~~ (On progress...)  
    ~~RDS: For a database~~ (On progress...)  
- **Terraform**  
    To create the infrastructure  
    Trigger Ansible to config the infrastructure when the infrastructure is created  
- **Ansible**  
    Config the infrastructure from Terraform, the steps are:  
    - Install Docker  
    - Add user to Docker's group  
    - Pull Docker image (daipham99/learning:0.2) and uses it to run a Docker container  

## The main flow  
- Create the infrastructure using Terraform
- An AWS EC2 instance gets created by Terraform
- Terraform triggers Ansible after creating the infrastructure successfully
- Ansible runs a playbook 
- The AWS EC2 instance is now fully configured by Ansible and ready to serve requests