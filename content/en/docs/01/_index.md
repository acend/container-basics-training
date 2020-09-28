---
title: "1. Installation"
weight: 1
---

## Try Docker without installation

The page <https://training.play-with-docker.com> offers additional tutorials which also come with an interactive shell. The disadvantage is that you have to create an account, but if you don't want to install Docker locally, this is a great way to do the exercises in this training using a browser-based Docker shell.

To do this lab with *Play with Docker*:

* Go to <https://labs.play-with-docker.com>
* Click on *Login*
* Enter your Docker login or register first.
* Click *ADD NEW INSTANCE* and you are ready to do this lab.


## Installation for Windows

Please follow the [instructions](https://docs.docker.com/docker-for-windows/install/#install-docker-for-windows-desktop-app) on Docker's official documentation to install Docker CE for Windows.

When asked to use Windows container, choose _NOT_ to.

{{% alert title="Note" color="primary" %}}
You don't have to register for a Docker Cloud account.
{{% /alert %}}


### Shell recommendation for Windows

We highly recommend to use the Bash emulation _Git Bash_ from [Git for Windows](https://gitforwindows.org/) to do the exercises in this training.


### Proxy configuration for Windows

If your organization has a proxy in place you have to set the proxy environment variables in order to be able to do `docker pull` or `docker push`.

Git Bash:

```bash
export HTTP_PROXY="http://<username>:<password>@<proxy>:<port>"
export HTTPS_PROXY="http://<username>:<password>@<proxy>:<port>"
```

{{% alert title="Note" color="primary" %}}
If you have special characters in your password, you have to encode them according to [Percent-encoding reserved characters](https://en.wikipedia.org/wiki/Percent-encoding#Percent-encoding_reserved_characters).
{{% /alert %}}

See also [setting the proxy environment variables on Windows](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon#proxy-configuration) for alternative instructions on setting proxy environment variables.


## Installation for Mac

Please follow the [instructions](https://docs.docker.com/docker-for-mac/install/) on Docker's official documentation to install Docker CE for Mac.

{{% alert title="Note" color="primary" %}}
You don't have to register for a Docker Cloud account.
{{% /alert %}}


### Proxy configuration for Mac

If your organization has a proxy in place you have to set the proxy environment variables in order to be able to do `docker pull` or `docker push`.

```bash
export http_proxy="http://<username>:<password>@<proxy>:<port>"
export https_proxy="http://<username>:<password>@<proxy>:<port>"
```

{{% alert title="Note" color="primary" %}}
If you have special characters in your password, you have to encode them according to [Percent-encoding reserved characters](https://en.wikipedia.org/wiki/Percent-encoding#Percent-encoding_reserved_characters).
{{% /alert %}}

See also [setting the proxy environment variables on Mac](https://docs.docker.com/docker-for-mac/#proxies) for alternative instructions on setting proxy environment variables.


## Installation for Linux

Please follow the instructions for your appropriate distribution to install Docker. The recommended way of installing is using the repository, except if you already know you're going to remove the package again soon.

* [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* [Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/)
* [Debian](https://docs.docker.com/install/linux/docker-ce/debian/)
* [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/)

Unrelated to what distribution you use, also have a look at the [Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/). Please note however that these are optional steps and some are quite advanced, so going with the default might be the most appropriate way to go.


### Proxy configuration for Linux

If your organization has a proxy in place you have to set the proxy environment variables in order to be able to do `docker pull` or `docker push`.

```bash
export http_proxy="http://<username>:<password>@<proxy>:<port>"
export https_proxy="http://<username>:<password>@<proxy>:<port>"
```

{{% alert title="Note" color="primary" %}}
If you have special characters in your password, you have to encode them according to [Percent-encoding reserved characters](https://en.wikipedia.org/wiki/Percent-encoding#Percent-encoding_reserved_characters).
{{% /alert %}}


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


> Question: So what's next?

Let's head over to the [next lab](../02/).
