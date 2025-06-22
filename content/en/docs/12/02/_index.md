---
title: "12.2 Docker Swarm"
weight: 14
sectionnumber: 12.2
---
## Installation

You can create a simple docker swarm server on any maschine in the same network.


### Creating a Swarm

First of all we need to run the following command:

```bash
docker swarm init
```


### Add nodes to swarm

As the cluster ha no been created we can just add another node by running:

```bash
docker swarm join --token ...
```

To display the token afterwards you can use the following:

```bash
docker swarm join-token manager
```


### Viewing the current nodes

Check all nodes which are part of the cluster

```bash
docker node ls
```


### Leaving the swarm

To remove one node you have to "leave" the swarm or remove it from the manager node

```bash
# Leaving the swarm
docker swarm leave

# Removing a node from the swarm
docker node rm worker1
```


## Deployments

The cluster is running, but empty. Let's change that!


### Deploy a service

Here we go:

```bash
docker service create --replicas 2 --name awesome-app quay.io/acend/example-web-go:latest
docker service ls
```


### Scale a service

Scale the service by increasing the replicas and inspect the config

```bash
docker service scale awesome-app=4
docker inspect awesome-app
```


### Deleting a service

To delete a service we can simply use this command.

```bash
docker service rm awesome-app
```
