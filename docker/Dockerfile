ARG WIREMOCK_VERSION 3.0.0-1
FROM wiremock/wiremock:${WIREMOCK_VERSION}

RUN apt update && apt install wget && wget https://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.6.2/jolokia-jvm-1.6.2-agent.jar -O /var/wiremock/lib/jolokia-jvm.jar

ENV JAVA_OPTS "-Xmx1024m -Xms1024m -javaagent:/var/wiremock/lib/jolokia-jvm.jar"

CMD ["--global-response-templating", "--no-request-journal", "--async-response-enabled", "true", "--port", "8080"]