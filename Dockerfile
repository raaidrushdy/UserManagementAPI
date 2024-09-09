# Use a multi-platform OpenJDK image
FROM arm64v8/openjdk:17-jdk-alpine
# Use the slim version of OpenJDK 17
FROM openjdk:17-jdk-slim

VOLUME /tmp
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]
