---
title: "4. Deleting containers"
weight: 4
---

## Deleting a container

There are two ways to stop a container, we start with the recommended way.
You first have to stop the container. Some might still know the CONTAINER ID or the NAME of the container but for those who don't:

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
699e82ed8f1f        mariadb             "docker-entrypoint..."   3 minutes ago       Up 3 minutes        3306/tcp            jolly_bardeen
7cb31f821233        mariadb             "docker-entrypoint..."   32 minutes ago      Up 32 minutes       3306/tcp            upbeat_blackwell
```

To stop a container you can use the command:

```bash
docker stop <container>
```
Then we check the new state with

```bash
docker ps
```
This should show only one container running now:
```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
699e82ed8f1f        mariadb             "docker-entrypoint..."   9 minutes ago       Up 9 minutes        3306/tcp            jolly_bardeen
```
We just exited the container "gracefully", but as an alternative you can also kill a container with the `docker kill <container>` command. This stops the container immediately by using the KILL signal.

You may recognize that the container *upbeat_blackwell* is not present in the container list anymore. That is because `docker ps` only shows running containers, but as always you have a parameter that helps:

```bash
docker ps --all
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                         PORTS               NAMES
699e82ed8f1f        mariadb             "docker-entrypoint..."   12 minutes ago      Up 12 minutes                  3306/tcp            jolly_bardeen
7cb31f821233        mariadb             "docker-entrypoint..."   41 minutes ago      Exited (0) 2 minutes ago                           upbeat_blackwell
67d79f95c712        hello-world         "/hello"                 About an hour ago   Exited (0) About an hour ago                       upbeat_boyd
```

Now that the *upbeat_blackwell* container is stopped we can delete it:

```bash
docker rm <container>
```

Now the container had disappeared from the list:

```bash
docker ps --all
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                         PORTS               NAMES
699e82ed8f1f        mariadb             "docker-entrypoint..."   13 minutes ago      Up 13 minutes                  3306/tcp            jolly_bardeen
67d79f95c712        hello-world         "/hello"                 About an hour ago   Exited (0) About an hour ago                       upbeat_boyd
```

{{% alert title="Note" color="primary" %}}
It is a good idea to delete unused containers to save disk space.
{{% /alert %}}

{{% details title="🤔 Where do these strange names of the containers come from?" %}}
The CONTAINER ID and the NAME is a unique identifier for a container. If we don't provide one, `docker` will come up with a unique name.
More on that in the [next lab](../05/)!

{{% /details %}}
