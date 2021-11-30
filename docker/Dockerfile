FROM openjdk:15-alpine

ARG WIREMOCK_VERSION 2.27.2

RUN mkdir -p /var/wiremock/lib/ && \
  wget https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-jre8-standalone/${WIREMOCK_VERSION}/wiremock-jre8-standalone-${WIREMOCK_VERSION}.jar \
  -O /var/wiremock/lib/wiremock-jre8-standalone.jar && \
  wget https://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.6.2/jolokia-jvm-1.6.2-agent.jar -O /var/wiremock/lib/jolokia-java-agent.jar  && \
  addgroup wiremock && \
  adduser --disabled-password --gecos '' --home /home/wiremock --ingroup wiremock wiremock && \
  chown --recursive wiremock:wiremock /home/wiremock


WORKDIR /tmp
USER wiremock
COPY entrypoint.sh /tmp/entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]