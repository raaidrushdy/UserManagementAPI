pipeline {
    agent any

    tools {
        maven 'Maven' // Ensure you have named the Maven tool in Jenkins
    }

    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'  // Your SonarQube server in Jenkins
        SONAR_HOST_URL = 'http://localhost:9000'  // Update with your SonarQube instance URL
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your_repo/your_project.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the code...'
                sh 'mvn clean package'
            }
            post {
                success {
                    archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                sh 'mvn test'
            }
        }

        stage('Code Quality Analysis') {
            steps {
                echo 'Running SonarQube analysis...'
                withSonarQubeEnv('SONARQUBE_SERVER') {
                    sh 'mvn sonar:sonar -Dsonar.host.url=$SONAR_HOST_URL'
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                echo 'Deploying to staging...'
                sh 'docker-compose down'
                sh 'docker-compose up -d'
            }
        }

        stage('Deploy to Production') {
            steps {
                echo 'Deploying to production...'
                sh 'docker build -f Dockerfile.prod -t user-management-api-prod .'
                sh 'docker run -d -p 8080:8080 --name user-management-api-prod user-management-api-prod'
            }
        }

        stage('Monitoring and Alerting') {
            steps {
                echo 'Monitoring...'
                // Example: sh 'prometheus --config.file=prometheus.yml'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished with status: ' + currentBuild.currentResult
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
