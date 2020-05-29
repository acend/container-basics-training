---
title: "14. Registry and Docker Hub"
weight: 14
---

So far we only built and ran the Docker images locally on our computers, but what if we want to integrate them into a CI/CD pipeline or even only distribute the built images?
Similar to a Maven artifact repo, where the built JARs, WARs, and EARs get deployed to distribute later, there is the concept of a Docker registry.

In this Lab we're going to learn:
* Docker Hub platform
* Pull and push images from and to the registry
* Create automated docker builds on Docker Hub

## Docker Hub

You might be wondering where the images and base images you ran in the previous labs came from, when not already present on your computer. They all came from the Docker Hub!

Docker Hub is an online Docker registry, repository management and build platform. It consists of public and private repositories. Docker Hub integrates with various online services such as GitHub or GitLab.

Publicly available images can be pulled without logging into the platform.

The following command pulls the `nginx` image to your local machine

```bash
docker pull nginx
```

```
Using default tag: latest
latest: Pulling from library/nginx
f17d81b4b692: Pull complete 
d5c237920c39: Pull complete 
a381f92f36de: Pull complete 
Digest: sha256:4ddaf6043a77aa145ce043d4c662e3768556421d6c0a65d303e89977ad3c9636
Status: Downloaded newer image for nginx:latest
```

Run the following command to verify whether the image is now locally available or not.

```bash
docker images
```

```
REPOSITORY                                               TAG                 IMAGE ID            CREATED             SIZE
nginx                                                    latest              dbfc48660aeb        4 hours ago         109MB
```

`docker run` or `docker build` does a `docker pull` implicitly when an image is not yet locally available.

### Create a Docker Hub account

Now it's time to prepare for pushing a docker image a Docker Hub repository. 

* Create a Docker Hub account if not already available: <https://hub.docker.com/>
* Create a new public repository: use the **Create Repository** button after you logged in.
* Check the repository info, the newly created repository is empty.

Now we need to login on our :

```bash
docker login
```

```
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <username>
Password: <password>
WARNING! Your password will be stored unencrypted in /home/home/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

### Push your first image

Let's push our "myfirstimage", we need to tag the image with the same name as the repository we've created previously:

```bash
docker tag myfirstimage <docker-user>/<docker-repo>
docker push <docker-user>/<docker-repo>
```

```
The push refers to repository docker.io/<docker-user>/<docker-repo>
213d31159bea: Pushed 
9f9cacfd69bf: Pushed 
a1950e3866f0: Mounted from library/php 
2dc96af1a4a5: Mounted from library/php 
8cb5b8d4756a: Mounted from library/php 
bcc4727d0912: Mounted from library/php 
59e338bee70e: Mounted from library/php 
369e6fd590f3: Mounted from library/php 
1805144065e1: Mounted from library/php 
b6311cdc5fb6: Mounted from library/php 
e30181a94bbf: Mounted from library/php 
481da43a1302: Mounted from library/php 
a4ace4ed0385: Mounted from library/php 
fd29e0f8792a: Mounted from library/php 
687dad24bb36: Mounted from library/php 
237472299760: Mounted from library/php 
latest: digest: sha256:604c7893ff67fab19fddcaaf89935f9bd252a8711e1d42ab3c8c837144b57eee size: 3659
```

### Tagging images

Tagging images allows us to keep track of different versions without the need of remembering the image ID, e.g. `ca751384b926`.
This said, a tag is a pointer to a specific image ID.

```bash
docker images
```

```
REPOSITORY                                               TAG                 IMAGE ID            CREATED             SIZE
myfirstimage                                             latest              ca751384b926        About an hour ago   368MB
puzzlelab/dockertechlab                                  1                   ca751384b926        About an hour ago   368MB
puzzlelab/dockertechlab                                  latest              ca751384b926        About an hour ago   368MB
nginx                                                    latest              dbfc48660aeb        5 hours ago         109MB
...
```

Tagging an image by ID:

```bash
docker tag <image-id> puzzlelab/dockertechlab:<tag>
```

Tagging an image by name:

```bash
docker tag myfirstimage puzzlelab/dockertechlab:<tag>
```

Tagging an image by name and tag:

```bash
docker tag myfirstimage:1 puzzlelab/dockertechlab:<tag>
```

Tagging an image for a private registry:

```bash
docker tag <image> myregistryhost:5000/puzzlelab/dockertechlab:<tag>
```

{{% alert title="Note" color="warning" %}}
Using the `latest` tag can be tricky. First of all it's important to define dependencies explicit and under version control, so that builds are reproducible. Second the latest tag basically means `"the last build/tag that ran without a specific tag/version specified"` https://medium.com/@mccode/the-misunderstood-docker-tag-latest-af3babfd6375
{{% /alert %}}


## Docker Enterprise 

Docker has its own enterprise features, which are available for Enterprises https://www.docker.com/products/docker-enterprise

## Docker Hub alternatives 

There are a couple of other public registries available, such as for example https://quay.io/

## Private registries

A docker registry can be deployed on premises as well. Most of the available artifact repository applications like for example Nexus and Artifactory are also able to manage Docker images. 

## Automated integrated Docker build from GitHub

It's pretty straight-forward to integrate Docker Hub together with projects on GitHub.

* Create a GitHub Repo, you might also want to fork this one
* Login on Docker Hub go to your dashboard
* Click **Create** an automated build
* Link GitHub account and create the automated build for the given repo
* Trigger the first build

Make a change in your `Dockerfile` and check for triggered builds.

## Additional lab

Visit <https://hub.docker.com/>, <https://docker.com/>, <https://quay.io/> and compare the features available for free and subscription based plans.
Take a look at the security image scan functionalities of those services.