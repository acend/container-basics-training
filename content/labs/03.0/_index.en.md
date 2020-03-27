---
title: "3.0 - Images"
weight: 30
---

Previously in the lab...

Question: Is there only a "hello world" Docker image?

Answer: No! There are tons of images provided by companies, open source projects, and boys/girls like you and me.

## Docker Images

You can search for images available on [Docker Hub](https://hub.docker.com) by using the Docker command with the `search` subcommand. For example, to search for a mariadb image, type:

`docker search mariadb`

The script will crawl Docker Hub and return a listing of all images whose name match the search string. In this case, the output will be similar to this:

```bash
NAME                                                      DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
mariadb                                                   MariaDB is a community-developed fork of M...   1516      [OK]
bitnami/mariadb                                           Bitnami MariaDB Docker Image                    41                   [OK]
paintedfox/mariadb                                        A docker image for running MariaDB 5.5, a ...   29                   [OK]
toughiq/mariadb-cluster                                   Dockerized Automated MariaDB Galera Cluste...   20                   [OK]
linuxserver/mariadb                                       A Mariadb container, brought to you by Lin...   19
million12/mariadb                                         MariaDB 10 on CentOS-7 with UTF8 defaults       14                   [OK]
webhippie/mariadb                                         Docker images for mariadb                       11                   [OK]
colinmollenhour/mariadb-galera-swarm                      MariaDb w/ Galera Cluster, DNS-based servi...   10                   [OK]
diegomarangoni/mariadb-galera                             Creates a MariaDB Galera Cluster                10                   [OK]
...
```

This output is corresponding with the search you can use on [Docker Hub](https://hub.docker.com/search/?isAutomated=0&isOfficial=0&page=1&pullCount=0&q=mariadb&starCount=0).

In the OFFICIAL column, OK indicates an image built and supported by the company behind the project. Once you've identified the image that you would like to use, you can download it to your computer using the pull subcommand, like so:

`docker pull mariadb`

**Note:** Care about security! Check the images before you run them.

* Is it an official image?
* What is installed?
  * Read the Dockerfile that was used to build the image
  * Check the base image

After an image has been downloaded, you may then run a container using the downloaded image with the `run` subcommand. If an image has not been downloaded when Docker is executed with the `run` subcommand, the Docker client will first download the image, then run a container using it:

`docker run hello-world:linux`

**Note:** Here we use the linux tag of the hello-world image to not use latest again.

To see the images that have been downloaded to your computer, type:

`docker images`

The output should look similar to the following:

```bash
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mariadb             latest              58730544b81b        2 weeks ago         397MB
hello-world         latest              1815c82652c0        2 months ago        1.84kB
hello-world         linux               1815c82652c0        2 months ago        1.84kB
```

The hello world container you ran in the previous lab is an example of a container that runs and exits, after emitting a test message. Containers, however, can be much more useful than that, and they can be interactive. After all, they are similar to virtual machines, only more resource-friendly.

As an example, let's run a container using the latest image of mariadb. The combination of the -i and -t switches gives you interactive shell access into the container:

`docker run -it mariadb`

An error is popping up!

```bash
error: database is uninitialized and password option is not specified
  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD
```

Question: What's wrong? Am I an idiot?

Check out the next lab.