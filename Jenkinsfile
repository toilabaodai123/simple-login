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
}