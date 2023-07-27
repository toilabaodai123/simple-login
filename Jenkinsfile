pipeline {
    agent any
    stages {
        stage('Check enviroment') {
            steps {
                sh "echo hi"
            }
<<<<<<< HEAD
        } 

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
=======
        }  
    }
>>>>>>> 4468f40 (update jenkins)
}