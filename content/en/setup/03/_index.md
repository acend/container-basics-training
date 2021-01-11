---
title: "Installation for Linux"
weight: 5
type: docs
sectionnumber: 1
---

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


## Next steps

When you're ready to go, head on over to the [labs](../../docs/) and begin with the training!
