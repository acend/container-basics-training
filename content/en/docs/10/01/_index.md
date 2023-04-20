---
title: "10.1 Multi-stage builds"
weight: 11
sectionnumber: 10.1
---

Often you're going to use some kind of libraries, tools or dependencies during the build phase of your application that are not necessary during the execution time of the container. We want to keep the actual artifact as independent and small as possible. So we often remove these dependencies in the docker build phase after the application itself is built.

Since docker version 17.05 there is a solution for that problem: the so called multi stage-builds.

In this lab you're going to learn how to use multistage builds and what they are good for.


## Purpose

If the application is not available as a prebuilt artifact, in many cases, the application itself gets built directly during the docker build process `docker build -t ...`


### Examples

Let's have a look at some examples:


#### Java Spring Boot Gradle build

The complete example can be found at <https://github.com/appuio/example-spring-boot-helloworld>

```Dockerfile
FROM registry.access.redhat.com/ubi9/openjdk-17

LABEL org.opencontainers.image.authors="midcicd@puzzle.ch" \
      io.k8s.description="APPUiO Example Spring Boot App" \
      io.k8s.display-name="APPUiO Spring Boot App" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="springboot"

EXPOSE 8080 9000

RUN mkdir -p /tmp/src/
ADD . /tmp/src/

RUN cd /tmp/src && sh gradlew build --no-daemon

RUN ln -s /tmp/src/build/libs/springboots2idemo*.jar /deployments/springboots2idemo.jar

```

During the docker build the actual application source code is added to the context and built using the `gradlew build` command.
Gradle in this case is only used during the build phase, since it produces a jar that is then executed with `java -jar ...` at execution time.

Build phase dependencies:

* Java
* Gradle

Runtime phase dependencies:

* Java


#### Static HTML, CSS, JS example

A docker image that serves  static content like HTML, CSS, JS which will only be served via a simple web server like nginx or Apache. We don't want/need the build tools to be in the resulting docker image.

During the build phase, tools are needed to do:

* Creating HTML from templates, for example with a rendering framework
* Installing Javascript dependencies with Yarn, NPM, ...
* Compiling CSS with less, Sass, ...
* Minify, uglify, caching
* Optimizing images, creating different sizes of the images
* And so on ...

during the execution time of the image, actually only the created static content must be available.


#### Go application

A go application is a great use case for multi-stage builds, since the resulting artifact is an executable binary containing every dependency that is needed to run the application. That means that the resulting docker image can be very small, so the base image we use is a simple alpine linux.

Multi stage Docker build:

```bash
FROM golang:1.9
WORKDIR /go/src/myapp
RUN go get -d -v golang.org/x/net/html
COPY app.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:3.6  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/myapp .
CMD ["./app"]
```

Content of the Go application `app.go`:

```go
package main
import (
        "net/http"
        "fmt"
)
func main() {
        http.HandleFunc("/", hello)
        http.ListenAndServe(":8180", nil)
}
func hello(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Docker workshop")
}
```


## Multi-stage builds

With multistage builds you now have the possibility to actually split these two phases, so that you can pass the built artifact from phase one into the runtime phase, without the need of installing build time dependencies in the resulting docker image. Which means that the image will be smaller and consist of less unneeded dependencies.

Read more about Docker multi-stage builds at <https://docs.docker.com/develop/develop-images/multistage-build/>


## Optional Lab: Create a multi-stage build

Turn the docker build from the first example (Java Spring boot <https://github.com/appuio/example-spring-boot-helloworld>) into a docker multistage build.

As a second image you can use `registry.access.redhat.com/ubi9/openjdk-17-runtime`. Try to find the solution before looking at it.

{{% details title="Show me the solution" %}}
```Dockerfile
FROM registry.access.redhat.com/ubi9/openjdk-17

LABEL org.opencontainers.image.authors="midcicd@puzzle.ch" \
      io.k8s.description="APPUiO Example Spring Boot App" \
      io.k8s.display-name="APPUiO Spring Boot App" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="springboot"

EXPOSE 8080 9000

RUN mkdir -p /tmp/src/
ADD . /tmp/src/

RUN cd /tmp/src && sh gradlew build --no-daemon

FROM registry.access.redhat.com/ubi9/openjdk-17-runtime

EXPOSE 8080 9000

COPY --from=0 /tmp/src/build/libs/springboots2idemo*.jar /deployments/springboots2idemo.jar
```
{{% /details %}}

