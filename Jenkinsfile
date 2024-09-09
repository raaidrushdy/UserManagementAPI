pipeline {
    agent any
    tools {
        maven 'Maven' // Configure Maven in Jenkins' global tool configuration
    }
    environment {
        SONARQUBE_SERVER = 'SonarQubeServer' // Set your SonarQube server name
        SONAR_TOKEN = credentials('sonar-token') // Use Jenkins credentials to securely store your SonarQube token
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/raaidrushdy/UserManagementAPI.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Code Quality Analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    sh 'mvn sonar:sonar -Dsonar.login=$SONAR_TOKEN'
                }
            }
        }
        stage('Deploy to Staging') {
            steps {
                sh 'docker-compose down'
                sh 'docker-compose up -d'
            }
        }
        stage('Release to Production') {
            steps {
                sh 'docker build -t user-management-api-prod .'
                sh 'docker run -d -p 8080:8080 user-management-api-prod'
            }
        }
        stage('Monitoring and Alerting') {
            steps {
                sh 'prometheus --config.file=prometheus.yml'
            }
        }
    }
    post {
        always {
            echo "Pipeline finished with status: ${currentBuild.currentResult}"
        }
    }
}
