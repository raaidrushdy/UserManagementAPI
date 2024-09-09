# Base Jenkins image
FROM jenkins/jenkins:lts

# Install New Relic Infrastructure Agent
USER root
RUN curl -o /etc/apt/sources.list.d/newrelic-infra.list https://download.newrelic.com/infrastructure_agent/linux/apt/dists/focal/main/binary-amd64/Packages \
  && echo "deb [signed-by=/etc/apt/trusted.gpg.d/newrelic-infra.gpg] https://download.newrelic.com/infrastructure_agent/linux/apt focal main" | tee /etc/apt/sources.list.d/newrelic-infra.list \
  && apt-get update \
  && apt-get install newrelic-infra -y

# Set New Relic license key
ENV NEW_RELIC_LICENSE_KEY=<your_new_relic_license_key>
USER jenkins
