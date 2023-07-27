pipeline {
    agent any
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