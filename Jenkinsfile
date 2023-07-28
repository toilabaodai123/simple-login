pipeline {
    agent any
    stages {
        stage('Check enviroment') {
            steps {
                sh """
                    git --version
                    docker version
                    aws --version
                    aws configure list
                """
            }
        }  
		
        stage('Get enviroment file development') {	
            steps {
                    sh """
                        cd app
						aws s3 cp s3://dai-jenkins/environment-files/development.env .
					"""
            }
        }			

        stage('Build and run container') {
            steps{
                sh """
					cd app
					docker run -u root -d --rm -v .:/app composer:2.5.8 sh -c "composer install"
                    docker build -t docker_image .
					docker run -d --name app docker_image
                """ 
            }
        }
		
        stage('Push to docker repo') {
            when {
                branch 'main'
            }  
            environment {
                DOCKER_HUB_CREDENTIALS = credentials("dockerhub")
            }                
            steps{
				sh """
				    cd app
				    docker login -u ${DOCKER_HUB_CREDENTIALS_USR} -p ${DOCKER_HUB_CREDENTIALS_PSW}
				    docker image tag docker_image daipham99/learning:latest
				    docker image push daipham99/learning:latest
				    docker logout
				"""
            }
        }
        
        stage("Deploy"){
            when {
                branch 'main'
            }  
            steps{
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh', keyFileVariable: 'MY_SSH_KEY')]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY ubuntu@13.250.101.14 sh '''#!/bin/bash
                            docker container stop app 
                            docker container rm app -f
                            docker container prune -f 
                            docker image prune -f
                            docker run -d --pull always -p 80:80 -p 443:443 --name app daipham99/learning:latest
                            docker exec -w /app app php artisan key:generate
                        ''' 
                    """
                }
            }
        }
        
    }
    post {
        always { 
            echo "------------Cleaning up...-------------"
            sh """
                docker image prune -f
                docker container stop app
                docker container prune -f
                docker image rm docker_image -f
                docker volume prune -f
            """
        }
    }
}