---
title: "15. additional Bestpractices"
weight: 15
---

In addition to the bestpractices under <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/> we encourage you to be aware of the following additional points

## Base images

* Use only trusted base images
* Use only regularly update and supported images
* If you use self built base images make sure to trigger the complete dependency chain of your application images
* Trigger your build when the base images got updated
* Use security scans to check your images for security issues
* Use the Red Hat supported base images when possible, be aware of the needed subscriptions