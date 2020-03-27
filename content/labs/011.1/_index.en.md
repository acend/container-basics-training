---
title: "11.1 - Multistage Builds"
weight: 111
---

Often you're going to use some kind of libraries, tools or dependencies during the build phase of your application, that are not necessary during the execution time of the container. And since we want to keep the actual artifact as independent and small as possible, we often remove these dependencies in the docker build phase after the application itself is built.

Since docker 17.05 they implemented a solution for that problem, the so called multi stage builds.

In this lab you're going to learn how to use multistage builds and what they are good for.

## Purpose

If the application is not available as prebuilt artifact, in many cases, the application itself gets built directly during the docker build process `docker build -t ...` 

Let's have a look at the following example:

### Java Spring Boot Gradle Build

The complete example can be found under https://github.com/appuio/example-spring-boot-helloworld

```
FROM centos/s2i-base-centos7

EXPOSE 8080
      
# Install Java
RUN INSTALL_PKGS="tar unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    mkdir -p /opt/s2i/destination

USER 1001
    
ADD ./gradlew /opt/app-root/src/
ADD gradle /opt/app-root/src/gradle
ADD build.gradle /opt/app-root/src/
ADD src /opt/app-root/src/src

# build the application from source
RUN sh /opt/app-root/src/gradlew build 

# copy the artifact to the correct location
RUN cp -a  /opt/app-root/src/build/libs/springboots2idemo*.jar /opt/app-root/springboots2idemo.jar 

CMD java -Xmx64m -Xss1024k -jar /opt/app-root/springboots2idemo.jar

```

During the docker build the actual application source code is added to the context and built using the `gradlew build` command.
Gradle in this case is only used during the build phase, since it produces a jar that is then executed with `java -jar ...` at execution time.

**Build phase dependencies**

* Java
* gradle

**Runtime phase dependencies**
* Java

#### Notes regarding Java in Docker

Java is not yet fully container-aware and by default configures itself according to the memory
available on the host instead of the memory available to the container. Red Hat images contain
logic to work around this limitation. For other images you may have to specify suitable heap size
options through an environment variable when starting containers.
The precise environment variable depends on the image, usually `JAVA_OPTIONS`.
The `_JAVA_OPTIONS` (yes, with leading underscore) environment variable, which is picked up directly
by the JDK, should also work. Also see: https://developers.redhat.com/blog/2017/03/14/java-inside-docker/
and https://blogs.oracle.com/java-platform-group/java-se-support-for-docker-cpu-and-memory-limits.

Note that only Java Docker images from [Azul](https://hub.docker.com/u/azul/),
[Red Hat](https://access.redhat.com/containers/),
[Oracle](https://store.docker.com/images/oracle-serverjre-8) (with costs)
and images based on the [CentOS image](https://hub.docker.com/_/centos/),
e.g. the [JBoss Java base image](https://hub.docker.com/r/jboss/base-jdk/) and
[Fabric8 Java base image](https://hub.docker.com/r/fabric8/java-jboss-openjdk8-jdk/)
are TCK certified and therefore guaranteed to work as specified in the various Java specifications.
In addition there are [legal concerns](https://www.infoq.com/news/2016/03/docker-java) when running
Oracle Java in Docker without the official image.

### Static HTML, CSS, JS example

A docker image that serves  static content like HTML, CSS, JS which will only be served via a simple Webserver like nginx or apache. We don't want/need the build tools to be in the resulting docker image.

During Build phase tools are needed to do:

* Creating HTML from templates, for example with a rendering framework
* Installing Javascript dependencies with Yarn, NPM, ...
* compiling CSS with less, Sass, ...
* minify, uglify, caching
* optimizing images, creating different sizes of the images
* and so on... 

during the execution time of the image, actually only the created static content must be available.

### Go application

A go application is a great use case for multi stage builds, since the resulting artifact is a executable binary containing every dependency that is needed to run the application. That means that the resulting docker image can be very small, so the base image we use is a simple alpine linux.

Multi stage Docker build:
```
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

## Multi Stage Builds

With multistage builds you now have the possibility to actually split these two phases, so that you can pass the built artifact from phase one into the runtime phase, without the need of installing build time dependencies in the resulting docker image. Which means that the image will be smaller and consists of less unneeded dependencies.

Read more about docker multi stage builds under https://docs.docker.com/develop/develop-images/multistage-build/


## LAB: create a multi stage build

Turn the docker build from the first example (Java Spring boot https://github.com/appuio/example-spring-boot-helloworld) into a docker multistage build.