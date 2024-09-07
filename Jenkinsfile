pipeline {
    agent any

    tools {
        maven 'maven' // Ensure the Maven installation is properly set in Jenkins under Global Tool Configuration
    }

    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'  // Replace with the name of your SonarQube server configuration in Jenkins
        SONAR_HOST_URL = 'http://your-sonarqube-url:9000'  // Update with your SonarQube host URL
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code from your SCM (e.g., GitHub, GitLab)
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building the code...'
                // Run the Maven build command
                sh 'mvn clean package'
            }
            post {
                success {
                    // Archive the built artifacts (like a JAR file) after a successful build
                    archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                // Run Maven unit tests
                sh 'mvn test'
            }
        }

        stage('Code Quality Analysis') {
            steps {
                echo 'Analyzing code with SonarQube...'
                withSonarQubeEnv(SONARQUBE_SERVER) {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        sh "mvn sonar:sonar " +
                           "-Dsonar.projectKey=User-Management-API " +
                           "-Dsonar.projectName='User Management API' " +
                           "-Dsonar.login=$SONAR_TOKEN " +
                           "-Dsonar.host.url=$SONAR_HOST_URL"
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
                // Build Docker image for production
                sh 'docker build -f Dockerfile.prod -t user-management-api-prod .'

                echo 'Running Docker container in production...'
                // Run Docker container in production
                sh 'docker run -d -p 8080:8080 --name user-management-api-prod user-management-api-prod'
            }
        }

        stage('Monitoring and Alerting') {
            steps {
                echo 'Setting up monitoring and alerting...'
                // Example: Monitoring setup command (e.g., using Prometheus)
                sh 'prometheus --config.file=prometheus.yml'
            }
        }
    }

    post {
        always {
            // Always display the result of the pipeline
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
