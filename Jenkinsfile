pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'
        SONAR_HOST_URL = 'http://10.0.0.143:9000'
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

                echo 'Stopping and removing old container (if exists)...'
                sh 'docker stop user-management-api-staging || true'
                sh 'docker rm user-management-api-staging || true'

                echo 'Running Docker container in staging...'
                sh 'docker run -d -p 8081:8080 --name user-management-api-staging user-management-api'
            }
        }

        stage('Deploy to Production') {
            steps {
                echo 'Building Docker image for production...'
                sh 'docker build -f Dockerfile.prod -t user-management-api-prod .'

                echo 'Running Docker container in production...'
                sh 'docker stop user-management-api-prod || true'
                sh 'docker rm user-management-api-prod || true'
                sh 'docker run --rm -d -p 8080:8080 --name user-management-api-prod user-management-api-prod'
            }
        }

        stage('Monitoring and Alerting with New Relic') {
            steps {
                echo 'Starting New Relic Infrastructure Agent...'
                withCredentials([string(credentialsId: 'new-relic-license-key', variable: 'NEW_RELIC_LICENSE_KEY')]) {
                    sh 'NEW_RELIC_LICENSE_KEY=$NEW_RELIC_LICENSE_KEY newrelic-infra start'
                }
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
