pipeline {
    agent any
    tools {
        maven 'Maven' // Ensure the Maven installation is properly set in Jenkins under Global Tool Configuration
    }
    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'  // Update this with the SonarQube server name you set in Jenkins
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/raaidrushdy/UserManagementAPI.git'
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
                echo 'Analyzing code with SonarQube...'
                withSonarQubeEnv('MySonarQubeServer') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=user-management-api -Dsonar.projectName="User Management API"'
                }
            }
        }
        }

        stage('Deploy to Staging') {
            steps {
                echo 'Deploying to staging using Docker Compose...'
                sh 'docker-compose down'
                sh 'docker-compose up -d'
            }
        }

        stage('Deploy to Production') {
            steps {
                echo 'Building Docker image for production...'
                sh 'docker build -f Dockerfile.prod -t user-management-api-prod .'

                echo 'Running Docker container in production...'
                sh 'docker run -d -p 8080:8080 --name user-management-api-prod user-management-api-prod'
            }
        }

        stage('Monitoring and Alerting') {
            steps {
                echo 'Setting up monitoring and alerting...'
                // Example command to configure Prometheus
                sh 'prometheus --config.file=prometheus.yml'
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
