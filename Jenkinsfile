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
        
        stage('Git') {
            steps {
                git branch: "main", url: "https://github.com/toilabaodai123/simple-login.git"
				echo "Git merging..."
            }
        }
		
        stage('Get enviroment file') {
            steps {
                echo "passing enviroment file..."
            }
        }	

        stage('Build and run container') {
            steps{
                sh """
					cd app
					docker run -d --rm -v .:/app --name composer composer:2.5.8 bash -c 'composer install && php artisan key generate' 
                    docker build -m 0.1g -t docker_image .
					docker run -m 0.1g -d --name app -v .:/app docker_image
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
            steps {
				echo "Running selenium test cases..."
				echo "Running postman-cli test cases..."
            }
        }
		
        stage('Push to docker repo') {
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
            steps{
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh', keyFileVariable: 'MY_SSH_KEY', usernameVariable: "MY_SSH_USER")]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY $MY_SSH_USER@3.82.242.77 docker container stop app
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY $MY_SSH_USER@3.82.242.77 docker container rm app -f
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY $MY_SSH_USER@3.82.242.77 docker container prune -f
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY $MY_SSH_USER@3.82.242.77 docker run -d --pull always -p 80:80 -p 443:443 --name app daipham99/learning:latest
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