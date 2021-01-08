---
title: "Setup"
weight: 2
type: docs
menu:
  main:
    weight: 1
---

## Docker architecture

* Docker is a client-server application
* The **Docker daemon** (or "Engine")
  * Receives and processes incoming Docker API requests
* The **Docker client**
  * Talks to the Docker daemon via the Docker API
  * We'll use mostly the CLI embedded within the Docker binary
* The **Docker Hub** Registry
  * Is a collection of public images
  * The Docker daemon talks to it via the registry API

The Docker installation will install the Docker daemon and client on your workstation.


## Setup introduction

This training depends on an installation of Docker.
Follow the instructions on the subsequent pages to complete the setup on your platform of choice.
