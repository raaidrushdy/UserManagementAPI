# Use a multi-platform OpenJDK image
FROM openjdk:17-jdk-slim

# Switch to root to install required packages
USER root

# Install New Relic Infrastructure Agent
RUN apt-get update \
    && apt-get install -y curl gnupg \
    && curl -s https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg | apt-key add - \
    && echo "deb https://download.newrelic.com/infrastructure_agent/linux/apt focal main" | tee /etc/apt/sources.list.d/newrelic-infra.list \
    && apt-get update \
    && apt-get install -y newrelic-infra

# Set the New Relic license key as an environment variable
ENV NEW_RELIC_LICENSE_KEY="b2c25ed7d68adfd140b8090a14389b79FFFFNRAL"

# Continue with your app setup
VOLUME /tmp
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

