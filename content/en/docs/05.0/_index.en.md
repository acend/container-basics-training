---
title: "5. Deleting containers"
weight: 5
---

Previously in the lab...

> Question: Do we need two running MariaDB containers at the same time for this lab?

Answer: No!

So let's delete a container!


## Deleting a container

As for every OS you can barely delete it when it is running!
So first we have to stop the container. Some might still know the CONTAINER ID or the NAME of the container but for those who don't:

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
699e82ed8f1f        mariadb             "docker-entrypoint..."   3 minutes ago       Up 3 minutes        3306/tcp            jolly_bardeen
7cb31f821233        mariadb             "docker-entrypoint..."   32 minutes ago      Up 32 minutes       3306/tcp            upbeat_blackwell
```

To stop a container, you can use the command:

```bash
docker stop <container>
```

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
699e82ed8f1f        mariadb             "docker-entrypoint..."   9 minutes ago       Up 9 minutes        3306/tcp            jolly_bardeen
```

As an alternative you can also kill a container with the `docker kill <container>` command. This stops the container immediately by using the KILL signal.

You may recognize that the container *upbeat_blackwell* is not present in the container list anymore. `docker ps` only shows running container but as always you have a parameter that helps:

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

```bash
docker ps --all
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                         PORTS               NAMES
699e82ed8f1f        mariadb             "docker-entrypoint..."   13 minutes ago      Up 13 minutes                  3306/tcp            jolly_bardeen
67d79f95c712        hello-world         "/hello"                 About an hour ago   Exited (0) About an hour ago                       upbeat_boyd
```

{{% alert title="Tip" color="info" %}}
Always try to clean up as every container is using space on your disk!
{{% /alert %}}

> Question: Where do these strange names come from?

Obviously you will find it out... in the next lab!
