---
title: "Installation for Windows"
weight: 3
type: docs
sectionnumber: 1
---

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


## Ready?

When you're ready to go, head on over to the [labs](../../docs/) and begin with the training!
