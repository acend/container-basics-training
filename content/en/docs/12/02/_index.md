---
title: "12.2 Docker Swarm"
weight: 14
sectionnumber: 12.2
---
## Installation

You can create a simple docker swarm server on any machine in the same network.

For this lab you hav to go together with your neighbour and create a cluster


### Creating a Swarm

First of all we need to run the following command on one shell:

```bash
docker swarm init
```


### Add nodes to swarm

As the cluster has now been created, we can just add another node by running:

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



## Services

The cluster is running, but really empty. Let's change that!


### Deploy a service

Here we go:

```bash
docker service create --replicas 2 --name awesome-app quay.io/acend/example-web-go:latest
```

Check the running service by one of these commands, it there a difference?

```bash
docker service ls
docker ps
```

Try this on both nodes!


### Scale a service

Scale the service by increasing the replicas and inspect the config

```bash
docker service scale awesome-app=4
docker inspect awesome-app
```

Where are the pods scheduled? Check all the nodes!


### Deleting a service

To delete a service we can simply use this command.

```bash
docker service rm awesome-app
```


## Stacks

Docker stacks is a collection of more than one service using the already known docker compose config.


### Creating a stack

Create a file called docker-compose.yaml with:

```yaml
version: "3.7"
services:
  nginx:
    image: quay.io/acend/example-web-go:latest
    ports: ["5000:5000"]
    deploy:
      replicas: 3
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: "0.1"
          memory: 100M
```

And deploy the stack with

```bash
docker stack deploy -c docker-compose.yaml stack-example-web-go
```


### Managing a stack

Check what we've got


```bash
docker stack ls
docker ps
```


### Delete  a stack

Finally we can delete this simple example by running:


```bash
docker stack rm stack-example-web-go
```


## Cleanup


### Leaving the swarm

To remove one node you have to "leave" the swarm or remove it from the manager node.

```bash
# Leaving the swarm
docker swarm leave

# Removing a node from the swarm
docker node rm worker1
```
