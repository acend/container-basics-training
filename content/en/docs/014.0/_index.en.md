---
title: "14. Registry and Docker Hub"
weight: 14
---

So far we only built and ran the Docker images locally on our computers, but what if we want to integrate them into a CI/CD pipeline or even only distribute the built images.
Similarily to a maven artefact repo, where the built jars, wars and ears get deployed to distribute later, there is the concept of a Docker registry.

In this Lab we're going to learn:
* Docker Hub Plattform
* pull and push images from the registry
* Create automated docker builds on docker hub

## Docker Hub

You might be wondering where the images and base images you ran in the previous labs came from, when not already present on your computer. They all came from the Docker Hub Registry.

Docker Hub is a online Docker registry, repository management and build plattform. It consists of public and private repositories. Docker Hub integrates with various online services such as Github or Bitbucket.

Publicly available images can be pulled with out loggin into the plattform.

The following command pulls the nginx image to your local machine
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

run the following command to verify whether the image is now locally available or not.

```bash
docker images
```

```
REPOSITORY                                               TAG                 IMAGE ID            CREATED             SIZE
nginx                                                    latest              dbfc48660aeb        4 hours ago         109MB
```

`docker run` or `docker build` does a `docker pull` impliciply when an image is not yet locally available.

### Create a Docker Hub account

Now its time to prepare for pushing a docker image a Docker Hub repository. 

* create a Docker Hub account if not already available
* create a new public repository (create repository Button after you logged in on https://hub.docker.com)
* check the repositroy info, the newly created repository is empty.

Now we need to login to docker hub with the docker tool
```bash
docker login
```

```
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: [USERNAME]
Password: 
WARNING! Your password will be stored unencrypted in /home/home/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

### Push Your First Image

let's push our "myfirstimage", we need to tag the image with the same name as the repository we've created previously
```bash
docker tag myfirstimage [Docker HUB USER]/[Repo]
docker push [Docker HUB USER]/[Repo]
```

```
The push refers to repository [docker.io/[Docker HUB USER]/[Repo]]
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

### Tagging Images

Tagging images allows us to keep track of different versions without the need of remembering the image ID eg.: `ca751384b926`
This said, a tag is a pointer to a specific image ID

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

**Tagging an Image by ID**

```bash
docker tag [IMAGE ID]  puzzlelab/dockertechlab:versionById
```

**Tagging an Image by Name**

```bash
docker tag myfirstimage puzzlelab/dockertechlab:versionByName
```

**Tagging an Image by Name and Tag**

```bash
docker tag myfirstimage:1 puzzlelab/dockertechlab:versionByNameAndTag
```

**Tagging an Image for a private Repository**

```bash
docker tag [IMAGE ID] myregistryhost:5000/puzzlelab/dockertechlab:version0.1
```

**Note:** using the latest tag can be tricky. First of all it's important to define dependencies explicit and under version control, so that builds are reproducable. Second the latest tag basically means `"the last build/tag that ran without a specific tag/version specified"` https://medium.com/@mccode/the-misunderstood-docker-tag-latest-af3babfd6375

## Docker Enterprise 

Docker has its own enterprise features, which are available for Enterprises https://www.docker.com/products/docker-enterprise

## Docker Hub alternatives 

There are a couple of other public registries available, such as for example https://quay.io/

## Private registries

A docker registry can be deployed on premises as well. Most of the available artefact repository applications like for example nexus and artifactory are also able to manage docker images. 

## Automated integrated Docker Build from Github

It's pretty straight forward to integrate Docker Hub together with projects on Github.

* create a Github Repo, you might also want to fork this one
* Login on Docker Hub go to your Dashboard
* Create an Automated Build (top navigation Create -->)
* Link Github Account and create the automated Build for the given Repo
* Trigger the first build

Make a change in your Dockerfile and check for triggered builds.


## Additional Lab

Visit https://hub.docker.com/, https://docker.com/, https://quay.io/ and compare the features available for free and subscription based plans.
Take a look at the security image scan functionalities of those services.