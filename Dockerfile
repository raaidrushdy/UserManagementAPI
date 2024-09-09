FROM jenkins/jenkins:lts

USER root

# Install necessary dependencies
RUN apt-get update && apt-get install -y curl gnupg2 ca-certificates lsb-release

# Add the New Relic GPG key
RUN curl -o /etc/apt/trusted.gpg.d/newrelic-infra.gpg https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg

# Add the New Relic repository
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/newrelic-infra.gpg] https://download.newrelic.com/infrastructure_agent/linux/apt $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/newrelic-infra.list

# Update package list and install New Relic Infrastructure Agent
RUN apt-get update && apt-get install -y newrelic-infra

# Switch back to Jenkins user
USER jenkins
