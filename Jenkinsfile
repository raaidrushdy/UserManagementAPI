pipeline {
    agent any

    tools {
        maven 'Maven' // This should match the name you gave Maven in Jenkins settings
    }

    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'  // Replace with the name of your SonarQube server configuration in Jenkins
        SONAR_HOST_URL = 'http://10.0.0.143:9000'  // Update with your machine's IP address and port
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/raaidrushdy/UserManagementAPI'
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
                withSonarQubeEnv(SONARQUBE_SERVER) {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        sh 'mvn sonar:sonar -Dsonar.login=$SONAR_TOKEN -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.projectKey=user-management-api-new -Dsonar.projectName="User Management API"'
                    }
                }
            }
        }


        stage('Deploy to Staging') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t user-management-api .'

                echo 'Running Docker container...'
                sh 'docker run -d -p 8080:8080 --name user-management-api user-management-api'
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
