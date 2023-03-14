---
title: "7. Frontend container"
weight: 7
---

Now that we have a "backend", why not deploy a frontend container (e.g. httpd & php) and make them speak to each other?


## Deploying a frontend container

First thing: Find the fitting Docker image --> Where? Exactly... [Docker Hub](https://hub.docker.com).

We use the `php:7-apache` image.

{{% onlyWhenNot mobi %}}
```bash
docker pull php:7-apache
```
{{% /onlyWhenNot %}}

{{% onlyWhen mobi %}}
```bash
docker pull <registry-url>/puzzle/k8s/kurs/php:7-apache
```
{{% /onlyWhen %}}

Once it is pulled let's have a look into `docker images`:

```bash
docker images
```

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
php                 7.0-apache          b8fe22aeffdf        5 days ago          390MB
mariadb             latest              58730544b81b        2 weeks ago         397MB
hello-world         latest              1815c82652c0        2 months ago        1.84kB
hello-world         linux               1815c82652c0        2 months ago        1.84kB

```

This will show us the images in our local registry with their respective name and tags.
When you use the `pull` command Docker will always pull down the latest versions of the repository but by requesting php:7-apache you have pulled a specific tag.
For the hello-world image we see, that we have the same image (read same image id) but two different tags (linux/latest).

Now we can deploy the new container using the correct tag.

{{% onlyWhenNot mobi %}}
```bash
docker run -d --name apache-php php:7-apache
```
{{% /onlyWhenNot %}}

{{% onlyWhen mobi %}}
```bash
docker run -d --name apache-php <registry-url>/puzzle/k8s/kurs/php:7-apache
```
{{% /onlyWhen %}}

With `docker ps` you see that the new container is running.

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
b901d6c0473a        php:7-apache        "docker-php-entryp..."   18 seconds ago      Up 17 seconds       80/tcp              apache-php
50197361e87b        mariadb             "docker-entrypoint..."   42 minutes ago      Up 42 minutes       3306/tcp            mariadb-container-with-existing-external-volume
6f08ac657320        mariadb             "docker-entrypoint..."   4 hours ago         Up 2 hours          3306/tcp            mariadb-container

```

Okay so let's try to connect to the server, via the container assigned docker IP address:

We use the familiar command from Lab 5:

```bash
docker inspect apache-php -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```
Which will show us only the IP as output:

```
172.17.0.4
```

With the IP from the inspection we can now navigate to the web server at <http://172.17.0.4>.

{{% alert title="Note for Webshell" color="primary" %}}
As we don't have a browser in the webshell use `curl http://172.17.0.4` to open the page in your terminal.
{{% /alert %}}

{{% alert title="Note for Windows and MacOS" color="primary" %}}
As the Docker Linux bridge is not reachable from your Windows or MacOS host you cannot access the container directly via IP address.
See:

* <https://docs.docker.com/docker-for-windows/networking/>
* <https://docs.docker.com/docker-for-mac/networking/>

If you've already started the `apache-php` container without port forwarding you have to stop and remove it first:

```bash
docker stop apache-php
docker rm apache-php
```

Now start the container again with port forwarding:

{{% onlyWhenNot mobi %}}
```bash
docker run -p 8080:80 -d --name apache-php php:7-apache
```
{{% /onlyWhenNot %}}

{{% onlyWhen mobi %}}
```bash
docker run -p 8080:80 -d --name apache-php <registry-url>/puzzle/k8s/kurs/php:7-apache
```
{{% /onlyWhen %}}

Now you can access the web server at <http://LOCALHOST:8080>.
{{% /alert %}}

Unfortunately we get a "403 Error - Forbidden".

{{% details title="🤔 Where is this error from? Docker?" %}}
403 is the error code from the apache container. There is some configuration missing:
The Apache web server does not allow you to scan its own document root.
{{% /details %}}

{{% details title="🤔 Can I only access the webserver through its local IP?" %}}
Docker can port-forward your request to a running containter. In the windows environment you have just used this feature. But more explanation in the next lab.
{{% /details %}}

For now let us stop and remove this container:

```bash
docker stop apache-php
docker rm apache-php
```
