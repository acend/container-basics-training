---
title: "14. Additional best practices"
weight: 14
---

In addition to the best practices under <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/> we encourage you to be aware of the following additional points


## Base images

* Use only trusted base images
* Use only regularly updated and supported images
* If you use self built base images make sure to trigger the complete dependency chain of your application images
* Trigger your build when the base images got updated
* Use security scans to check your images for security issues
