pipeline {
    agent any
    stages {
        stage('Check enviroment') {
            steps {
                sh """
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
					docker run -d --name app docker_image 					
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
		
        stage('Deploy') {
            steps{
				echo "Deploying..."
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
            """
        }
    }
}