pipeline {
    agent any
    stages {
        stage('Check enviroment') {
            steps {
                sh """
                    git --version
                    docker version
                """
            }
        }  
		
        stage('Get enviroment file') {	
            steps {
                    sh """
						cp ./app/.env.example ./app/.env
					"""
            }
        }			

        stage('Build and run container') {
            steps{
                sh """
					cd app
					docker run -d --rm -v .:/app -w /app composer:2.5.8 sh -c "composer install;php artisan key:generate"
                    docker build -t docker_image .
					docker run -d --name app -v .:/app docker_image
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
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY ubuntu@13.229.115.184 docker container stop app 
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY ubuntu@13.229.115.184 docker container rm app -f
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY ubuntu@13.229.115.184 docker container prune -f   
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY ubuntu@13.229.115.184 docker image prune -f
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY ubuntu@13.229.115.184 docker run -d --pull always -p 80:80 -p 443:443 --name app daipham99/learning:latest   
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY ubuntu@13.229.115.184 docker exec -w /app php artisan key:generate
                    """
                }
            }
        }
        
    }
    post {
        always { 
            echo '------------Cleaning up...-------------'
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