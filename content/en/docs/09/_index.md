---
title: "9. Linking frontend and backend"
weight: 9
---

Now it is time to link your frontend and backend together.


## Linking containers

If you have properly worked through all the previous labs you now have the following setup:

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
6b0721fa6103        php:8-apache        "docker-php-entryp..."   25 minutes ago      Up 25 minutes       0.0.0.0:8080->80/tcp   apache-php
50197361e87b        mariadb             "docker-entrypoint..."   2 hours ago         Up 2 hours          3306/tcp             mariadb-container-with-existing-external-volume
6f08ac657320        mariadb             "docker-entrypoint..."   5 hours ago         Up 3 hours          3306/tcp             mariadb-container
```

We will put the containers into a new, dedicated network. But first get rid of the currently running ones:

```bash
docker stop apache-php mariadb-container mariadb-container-with-existing-external-volume
docker rm apache-php mariadb-container mariadb-container-with-existing-external-volume
```

To enable communication between containers, use `docker network`. By default, Docker provides three networks. Verify this is the case:

```bash
docker network ls
```
Will output the following:
```
NETWORK ID          NAME                DRIVER              SCOPE
9233283df4a6        bridge              bridge              local
640877f8aec4        host                host                local
72f9a9996909        none                null                local
```

For this exercise create a new network with:

```bash
docker network create container-basics-training
```

If you rerun the list command for Docker networks now, `container-basics-training` will show up.

To make the backend accessible from the frontend run both containers with the `--network` option:

Linux/Webshell:

```bash
docker run -d --network container-basics-training --name apache-php -v $(pwd)/php-app:/var/www/html -p 8080:80 php:8-apache
docker run -d --network container-basics-training --name mariadb-container-with-existing-external-volume -v volume-mariadb:/var/lib/mysql -e MARIADB_ROOT_PASSWORD=my-secret-pw mariadb
```

Windows (Git Bash):

```bash
MSYS_NO_PATHCONV=1 docker run -d --network container-basics-training --name apache-php -v $(pwd)/php-app:/var/www/html -p 8080:80 php:8-apache
docker run -d --network container-basics-training --name mariadb-container-with-existing-external-volume -v volume-mariadb:/var/lib/mysql -e MARIADB_ROOT_PASSWORD=my-secret-pw mariadb
```

If you access either container, you should be able to resolve the other container's address with its container name.

Execute an interactive `bash` shell on the mariadb container.

``` bash
docker exec -it mariadb-container-with-existing-external-volume bash
```

You are now in the Bash session of the mariadb container and the prompt will look like `root@6f08ac657320:/#`

Get the address of the `apache-php` container.

``` bash
getent hosts apache-php
```

The two containers are now able to talk to each other. But let's check this:

If you type <http://localhost:8080/db.php> in your browser or use `curl http://localhost:8080/db.php` in the webshell you get... an error!
This is because the mysqli extension is not installed in the container.

Obviously, we will not install it in the running container but build a new image. More on that in the next lab.
