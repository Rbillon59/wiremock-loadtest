# Wiremock dockerized for performance testing

> [Wiremock](http://wiremock.org) standalone HTTP server Docker image

## Why for performance testing ?

By default, Wiremock is not configured to handle an heavy load. Here is what is changed in the configuration :

- `--no-request-journal` --> By default, Wiremock keep all requests logs in the Java heap, so a memory exhaust happen, fast. We disabled it
- `--async-response-enabled=true` --> By default, request responses are synchronous, here async

You can also use the same command line arguments as the standalone jar. Like this

```sh
docker run -d --rm -p 8080:8080 -v "${PWD}/mappings":/home/wiremock/mappings rbillon59/wiremock-loadtest:latest
```

Also, the Java agent Jolokia have been installed beside to be able to monitor the JVM behaviour during your load tests

## How to use this image

#### Getting started

##### Pull latest image

The image tags are the reflect of the official repository git tags (updated every days at 12h30). For example

```sh
docker pull rbillon59/wiremock-loadtest:latest
```

##### Start a Wiremock container

Default port is 8080 but you can change it with the ${PORT} environement variable (for the internal container service port)

```sh
docker run -d --rm -p 8080:8080 -v "${PWD}/mappings":/home/wiremock/mappings rbillon59/wiremock-loadtest:latest
```

##### Running multiple instances of Wiremock behind a reverse proxy

```sh
cd docker-compose && docker-compose up --scale wiremock=5 -d
```
 
Doing this you will spawn 5 instances of the mock behind a nginx reverse proxy which will load balance across the instances. It's useful to quickly launch multiple instance across a single host.

##### Running inside a kubernetes cluster

Update your wiremock mappings in the `mappings` folder, then create the configmap resource

```sh
# Create the kubernetes configmaps from the mappings folder
kubectl create configmap wiremock-mapping --from-file=mappings
kubectl apply -R -f k8s/
```

To update the configmap of a already running deployment, run :

```sh
# Replace the kubernetes configmaps
kubectl create configmap wiremock-mapping --from-file=mappings -o yaml --dry-run=client | kubectl replace -f -
# Restart the pods so they get the right version of the configMap
kubectl delete pods -l type=wiremock
```

The kubernetes.yaml file contains a definition of the wiremock deployment and a load balancer service to expose wiremock (no need for a specific nginx). You can deploy this inside your kubernetes cluster to mock direcly beside your application.  

The horizontal auto scaler will scale up the replicas if the CPU threshold is reached
--> The metric server is mandatory to expose the CPU metric to the Kubernetes API for the HPA to work

#### Samples

Two examples mappings are available in the samples/stubs/mappings folder. /static is a pre-defined json body while /dynamic take the path to create the json response.

> Access [http://localhost:8080/static](http://localhost:8080/static) to show static json message  
> Access [http://localhost:8080/dynamic/whatever](http://localhost:8080/dynamic/whatever) to show dynamic json message

