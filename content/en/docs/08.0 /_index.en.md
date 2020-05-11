---
title: "8. Frontend Container"
weight: 8
---

Previously in the lab...

> Question: I'm feeling like a Docker king... What's next?

Answer: Now that we have a "backend", why not deploy a frontend container (e.g. httpd & php) and make them speak with each other?

## Deploying a Frontend Container

First thing: Find the fitting Docker image --> Where? Exactly... [Docker Hub](https://hub.docker.com).

I would recommend the php:7-apache image.

```bash
docker pull php:7-apache
```

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

Besides the known mariadb image there is one new image. Also the php REPOSITORY has another TAG than the other REPOSITORIES.
When you use the `pull` command Docker will always pull down the latest versions of the REPOSITORY but by requesting php:7-apache you have pulled a specific TAG.
So Docker labels it that way.

>
> Here's some background info about images and containers.
>
> Question: What's an image?
>
> * An image is a collection of files + some meta data (or in technical terms: those files form the root filesystem of a container)
> * Images are made of layers, conceptually stacked on top of each other
> * Each layer can add, change, and remove files
> * Images can share layers to optimize disk usage, transfer times and memory use
>
> Question: What's the difference between a container and an image?
>
> * An image is a read-only filesystem
> * A container is an encapsulated set of processes running in a read-write copy of that filesystem
> * To optimize container boot time, copy-on-write is used instead of regular copy
> * docker run starts a container from a given image
>
> Images are like templates or stencils that you can create containers from.

Now we can deploy the new container using the correct tag.

```bash
docker run -d --name apache-php php:7-apache
```

With `docker container ls` you see that the new container is running.

```bash
docker container ls
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
b901d6c0473a        php:7-apache        "docker-php-entryp..."   18 seconds ago      Up 17 seconds       80/tcp              apache-php
50197361e87b        mariadb             "docker-entrypoint..."   42 minutes ago      Up 42 minutes       3306/tcp            mariadb-container-with-existing-external-volume
6f08ac657320        mariadb             "docker-entrypoint..."   4 hours ago         Up 2 hours          3306/tcp            mariadb-container

```

Okay so let's try to connect to the server, via the container assigned docker IP address:

```bash
docker inspect apache-php | grep IPAddress
```

```
[...]
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.4",
                    "IPAddress": "172.17.0.4",
[...]
```

With the IP from the inspection we can now navigate to the webserver at <http://172.17.0.4>.

{{% alert title="Windows and Mac Users" color="warning" %}}
As the docker linux brige is not reachable from your Windows or MacOS host you cannot access the container directly via IP Adress.
See:

* <https://docs.docker.com/docker-for-windows/networking/>
* <https://docs.docker.com/docker-for-mac/networking/>

Use port forwarding to access the container.
{{% /alert %}}

{{% alert title="Note for play-with-docker.com" color="warning" %}}
This is not possible without port forwarding, see next lab.
{{% /alert %}}

**Note:** It might be that your local firewall blocks requests to this address.

And unfortunatly we get a "403 Error - Forbidden".

**Note:** Do not forget to remove the existing instance of the apache-php container.

> Question: Why? Why do I get this error? And is there no other way to access the webserver via the private IP?

Go on and find the answers in the next lab.