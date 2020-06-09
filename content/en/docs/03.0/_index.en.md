---
title: "3. Images"
weight: 3
---

Previously in the lab...

> Question: Is there only a "hello world" Docker image?

Answer: No! There are tons of images provided by companies, open source projects, and boys/girls like you and me.


## Docker images

You can search for images available on [Docker Hub](https://hub.docker.com) by clicking the **Explore** link or by typing `mariadb` in the search field: <https://hub.docker.com/search/?q=mariadb&type=image>

You will get a list of results, and the first hit will probably be the official image: <https://hub.docker.com/_/mariadb>

This page contains instructions how to pull the image. Let's do that:

```bash
docker pull mariadb
```

{{% alert title="Note" color="warning" %}}
Care about security! Check the images before you run them.
{{% /alert %}}

* Is it an official image?
* What is installed?
  * Read the Dockerfile that was used to build the image
  * Check the base image

After an image has been downloaded, you may then run a container using the downloaded image with the `run` sub command. If an image has not been downloaded when Docker is executed with the `run` sub command, the Docker client will first download the image, then run a container using it:

```bash
docker run hello-world:linux
```

{{% alert title="Note" color="warning" %}}
Here we use the linux tag of the hello-world image to not use latest again.
{{% /alert %}}

To see the images that have been downloaded to your computer, type:

```bash
docker images
```

The output should look similar to the following:

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mariadb             latest              58730544b81b        2 weeks ago         397MB
hello-world         latest              1815c82652c0        2 months ago        1.84kB
hello-world         linux               1815c82652c0        2 months ago        1.84kB
```

The hello world container you ran in the previous lab is an example of a container that runs and exits, after emitting a test message. Containers, however, can be much more useful than that, and they can be interactive. After all, they are similar to virtual machines, only more resource-friendly.

As an example, let's run a container using the latest image of MariaDB. The combination of the -i and -t switches gives you interactive shell access into the container:

```bash
docker run -it mariadb
```

An error is popping up!

```
error: database is uninitialized and password option is not specified
  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD
```

> Question: What's wrong? Am I an idiot?

Check out the next lab.
