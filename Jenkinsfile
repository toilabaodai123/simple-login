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
    }

    stages {
        stage('For main branch') {
            when {
                branch "main"
            }            
            steps {
                echo "for main branch..."
            }
        } 

        stage('For feature branches') {
            when {
                 branch pattern: "feature-\\d+", comparator: "REGEXP"
            }            
            steps {
                echo "for feature branch..."
            }
        }         
    }    
}