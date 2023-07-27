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
		
        stage('Get enviroment') {	
            steps {
			    if (env.BRANCH_NAME == "main") {                                          
					sh """
						cp ./app/.env.example ./app/.env
					"""
				} else {                                   
					sh """
						cp ./app/.env.example ./app/.env
					"""
				} 
               
            }
        }			

        stage('Build and run container') {
            steps{
                sh """
					cd app
					docker run -d --rm -v .:/app composer:2.5.8 bash -c 'composer install' 
                    docker build -m 0.1g -t docker_image .
					docker run -m 0.1g -d --name app -v .:/app docker_image
                    docker exec -u root app bash -c "cd app && php artisan key:generate"
                """ 
            }
        }		

        stage('Testing...') {
            steps {
				echo "Running selenium test cases..."
				echo "Running postman-cli test cases..."
            }
        }        
		
        stage('Quality Testing...') {
            when {
                branch 'main'
            }  

            steps {
				echo "Running selenium test cases..."
				echo "Running postman-cli test cases..."
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
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh', keyFileVariable: 'MY_SSH_KEY', usernameVariable: "MY_SSH_USER")]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY $MY_SSH_USER@13.229.115.184 bash <<< EOF
                            docker container stop app
                            docker container rm app -f
                            docker container prune -f
                            docker image prune -f
                            docker run -d --pull always -p 80:80 -p 443:443 --name app daipham99/learning:latest
                        EOF
                    """
                }
            }
        }
        
    }
    post {
        always { 
            echo '------------Cleaning up...-------------'
            sh """
                docker container stop app
                docker container prune -f
                docker image rm docker_image -f
                docker volume prune -f
            """
        }
    }
}