#!/bin/sh

if [ -z ${PORT} ]; then
  PORT=8080
fi

if [ "$#" -eq 0 ]; then
  wiremock_args="--port ${PORT} --no-request-journal --async-response-enabled=true --global-response-templating"
else
  wiremock_args="$@"
fi

cd /home/wiremock && java -javaagent:/var/wiremock/lib/jolokia-java-agent.jar=port=8778,host=0.0.0.0 -cp /var/wiremock/lib/*:/var/wiremock/extensions/* com.github.tomakehurst.wiremock.standalone.WireMockServerRunner ${wiremock_args}