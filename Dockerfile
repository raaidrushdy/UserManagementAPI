# Use a multi-platform OpenJDK image
FROM arm64v8/openjdk:17-jdk-alpine
# Use the slim version of OpenJDK 17
FROM openjdk:17-jdk-slim

VOLUME /tmp
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

# Install New Relic Infrastructure Agent
USER root
RUN curl -o /etc/apt/sources.list.d/newrelic-infra.list https://download.newrelic.com/infrastructure_agent/linux/apt/dists/focal/main/binary-amd64/Packages \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/newrelic-infra.gpg] https://download.newrelic.com/infrastructure_agent/linux/apt focal main" | tee /etc/apt/sources.list.d/newrelic-infra.list \
    && apt-get update \
    && apt-get install newrelic-infra -y
USER jenkins

ENTRYPOINT ["java", "-jar", "/app.jar"]
