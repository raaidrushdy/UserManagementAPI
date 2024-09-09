# Use a multi-platform OpenJDK image
FROM arm64v8/openjdk:17-jdk-alpine
# Use the slim version of OpenJDK 17
FROM openjdk:17-jdk-slim

# Switch to root user to install New Relic agent
USER root

# Install New Relic Infrastructure Agent
RUN curl -o /etc/apt/sources.list.d/newrelic-infra.list https://download.newrelic.com/infrastructure_agent/linux/apt/dists/focal/main/binary-amd64/Packages \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/newrelic-infra.gpg] https://download.newrelic.com/infrastructure_agent/linux/apt focal main" | tee /etc/apt/sources.list.d/newrelic-infra.list \
    && apt-get update \
    && apt-get install newrelic-infra -y

# Set the New Relic license key as an environment variable
ENV NEW_RELIC_LICENSE_KEY=b2c25ed7d68adfd140b8090a14389b79FFFFNRAL

# Start New Relic Infrastructure agent
RUN newrelic-infra start

# Add application files
VOLUME /tmp
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

# Start the application
ENTRYPOINT ["java", "-jar", "/app.jar"]
