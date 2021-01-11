---
title: "Installation for Mac"
weight: 4
type: docs
sectionnumber: 1
---

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


## Next steps

When you're ready to go, head on over to the [labs](../../docs/) and begin with the training!
