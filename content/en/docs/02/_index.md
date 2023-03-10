---
title: "2. Images"
weight: 2
---

## Docker images

You can search for images available on [Docker Hub](https://hub.docker.com) by clicking the **Explore** link or by typing `mariadb` into the search field: <https://hub.docker.com/search/?q=mariadb&type=image>

You will get a list of results and the first hit will probably be the official image: <https://hub.docker.com/_/mariadb>

This page contains instructions on how to pull the image. Let's do that:

```bash
docker pull mariadb
```

{{% alert title="Note" color="primary" %}}
Care about security! Check the images before you run them.
{{% /alert %}}

* Is it an [official image](https://docs.docker.com/docker-hub/official_images/)?
* What is installed in the image?
  * Read the Dockerfile that was used to build the image
  * Check the base image

After an image has been downloaded, you may then run a container using the downloaded image with the sub-command `run`. If an image has not been downloaded when Docker is executed with the sub-command `run`, the Docker client will first download the image, then run a container using it:

```bash
docker run hello-world:linux
```

{{% alert title="Note" color="primary" %}}
Here we use the `linux` tag of the hello-world image instead of using `latest` again.
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

As an example, let's run a container using the latest image of MariaDB. The combination of the -i and -t switches gives you interactive shell access to the container:

```bash
docker run -it mariadb
```

{{% alert title="Note" color="primary" %}}
If you are on a Windows system, be aware of the error:

```
the input device is not a TTY.  If you are using mintty, try prefixing the command with 'winpty'
```

Put `winpty` at the beginning of every command that uses the `-it` paramaters. E.g.:

```bash
winpty docker run -it mariadb
```

{{% /alert %}}

An error has popped up!

```
2022-08-09 08:19:21+00:00 [Note] [Entrypoint]: Entrypoint script for MariaDB Server 1:10.8.3+maria~jammy started.
2022-08-09 08:19:21+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
2022-08-09 08:19:21+00:00 [Note] [Entrypoint]: Entrypoint script for MariaDB Server 1:10.8.3+maria~jammy started.
2022-08-09 08:19:21+00:00 [ERROR] [Entrypoint]: Database is uninitialized and password option is not specified
        You need to specify one of MARIADB_ROOT_PASSWORD, MARIADB_ALLOW_EMPTY_ROOT_PASSWORD and MARIADB_RANDOM_ROOT_PASSWORD
```

{{% details title="Question: Why do I get an error? Is this a bug in the image?" %}}
Everything is fine, to run this image there is some configuration needed. Read the following exerpt carefully.

```
error: database is uninitialized and password option is not specified
        You need to specify one of MARIADB_ROOT_PASSWORD, MARIADB_ALLOW_EMPTY_ROOT_PASSWORD and MARIADB_RANDOM_ROOT_PASSWORD
```
More on passing configuration to containers in the [next lab](../03/).
{{% /details %}}
