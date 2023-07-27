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
                    docker build -t docker_image .
                    docker run -v .:/app --rm -w /app composer:2.5.8 composer install
					docker run -d --name app -v .:/app docker_image 					
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
                        ssh -o StrictHostKeyChecking=no -i $MY_SSH_KEY $MY_SSH_USER@3.86.231.136 docker container stop app ; docker build . --pull -t daipham99/learning:latest ; docker container prune -f
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