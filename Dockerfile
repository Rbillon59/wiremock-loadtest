FROM openjdk:8-jre-alpine

ENV WIREMOCK_VERSION 2.27.2

RUN mkdir -p /var/wiremock/lib/ \
  && wget https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-jre8-standalone/$WIREMOCK_VERSION/wiremock-jre8-standalone-$WIREMOCK_VERSION.jar \
  -O /var/wiremock/lib/wiremock-jre8-standalone.jar

WORKDIR /home/wiremock

CMD java -Dcom.sun.management.jmxremote=true \
  -Dcom.sun.management.jmxremote.rmi.port=9010 \
  -Dcom.sun.management.jmxremote.port=9010 \
  -Dcom.sun.management.jmxremote.ssl=false \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.local.only=false \
  -cp /var/wiremock/lib/*:/var/wiremock/extensions/* com.github.tomakehurst.wiremock.standalone.WireMockServerRunner --no-request-journal --async-response-enabled=true --local-response-templating