---
title: "1. Installation"
weight: 1
---

## Try Docker without installation

The page <https://training.play-with-docker.com> offers additional tutorials which also come with an interactive shell. The disadvantage is that you have to create an account, but if you don't want to install Docker locally, this is a great way to do the exercises in this techlab using a browser-based Docker shell.

To do this lab with *Play with Docker*:

* Go to <https://labs.play-with-docker.com>
* Click on Start
* Enter your Docker Login or register first.
* Click *ADD NEW INSTANCE* and you are ready to do this lab.


## Installation for Windows and Mac

Please follow the instructions on Docker's official documentation to install Docker CE.

When asked to use Windows container, choose _NOT_ to.

{{% alert title="Tip" color="info" %}}
You don't have to register for a Docker Cloud account.
{{% /alert %}}

* [Windows](https://docs.docker.com/docker-for-windows/install/#install-docker-for-windows-desktop-app)
* [Mac](https://docs.docker.com/docker-for-mac/install/)


### Proxy configuration

If your organization has a proxy in place you have to configure it in your Docker configuration in order to be able to do `docker search` or `docker pull`.

* [Instructions to configure a proxy on Windows](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon#proxy-configuration)
* [Instructions to configure a proxy on Mac](https://docs.docker.com/docker-for-mac/#proxies)


## Installation for Linux

Follow the instructions for your appropriate distribution. The recommended way of installing is using the repository, except if you already know you're going to remove the package again soon.

* [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* [Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/)
* [Debian](https://docs.docker.com/install/linux/docker-ce/debian/)
* [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/)

Unrelated to what distribution you use, also have a look at the post-installation steps. Please note however that these are optional steps, and some are quite advanced, so going with the default might be the most appropriate way to go.

* [Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/)

## Docker architecture

* Docker is a client-server application.
* The **Docker daemon** (or "Engine")
  * Receives and processes incoming Docker API requests
* The **Docker client**
  * Talks to the Docker daemon via the Docker API
  * We'll use mostly the CLI embedded within the Docker binary
* The **Docker Hub** Registry
  * Is a collection of public images
  * The Docker daemon talks to it via the registry API