# Wiremock dockerized for performance testing

> [Wiremock](http://wiremock.org) standalone HTTP server Docker image

## Why for performance testing ?

By default, Wiremock is not configured to handle an heavy load. Here is what is changed in the configuration :

- `--no-request-journal` --> By default, Wiremock keep all requests logs in the Java heap, so a memory exhaust happen, fast. We disabled it
- `--async-response-enabled=true` --> By default, request responses are synchronous, here async

## How to use this image

#### Getting started

##### Pull latest image

```sh
docker pull rbillon59/wiremock-loadtest
```

##### Start a Wiremock container

```sh
docker run --rm -p 8080:8080 -v "${PWD}/samples/stubs":/home/wiremock rbillon59/wiremock-loadtest
```

##### Running multiple instances of Wiremock behind a reverse proxy

```sh
docker-compose up --scale wiremock=5 -d
```
 
Doing this you will spawn 5 instances of the mock behind a nginx reverse proxy which will load balance across the instances. It's useful to quickly launch multiple instance across a single host.

##### Running inside a kubernetes cluster

You need to update the volume mount path with the absolute path to the repository. It's necessary to put the mappings inside the pods.

```yaml
volumes:
        - name: stubs
          hostPath:
            path: <absolute_path_to_the_repo>/samples/stubs
```

```sh
kubectl apply -f kubernetes.yaml
```

The kubernetes.yaml file contains a definition of the wiremock deployment and a load balancer service to expose wiremock (no need for a specifif nginx). You can deploy this inside your kubernetes cluster to mock direcly beside your application.  

The horizontal auto scaler will scale up the replicas if the CPU threshold is reached

#### Samples

Two examples mappings are available in the samples/stubs/mappings folder. /static is a pre-defined json body while /dynamic take the path to create the json response.

> Access [http://localhost:8080/static](http://localhost:8080/static) to show static json message  
> Access [http://localhost:8080/dynamic/whatever](http://localhost:8080/dynamic/whatever) to show dynamic json message

