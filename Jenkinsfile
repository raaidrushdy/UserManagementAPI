pipeline {
    agent any

    tools {
        maven 'Maven' // This should match the name you gave Maven in Jenkins settings
    }

    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'  // Replace with your SonarQube server configuration in Jenkins
        SONAR_HOST_URL = 'http://sonarqube:9000'  // Use the Docker network host if Jenkins and SonarQube are in different containers
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

        // Integrating the SonarQube Analysis block you provided
        stage('SonarQube Analysis') {
            steps {
                echo 'Running SonarQube Analysis...'
                def mvn = tool 'Maven' // Ensure the Maven installation is properly set in Jenkins under Global Tool Configuration
                withSonarQubeEnv(SONARQUBE_SERVER) {
                    sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=User-Management-API -Dsonar.projectName='User Management API'"
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
