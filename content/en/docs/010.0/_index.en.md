---
title: "10. Linking frontend and backend"
weight: 10
---

Previously in the lab...

> Question: Can I somehow link the containers together, so they can talk to each other?

Answer: Yes, you can! Here's how it works.

## Linking containers

If you have properly worked through all the previous labs you should now have the following setup:

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
6b0721fa6103        php:7-apache        "docker-php-entryp..."   25 minutes ago      Up 25 minutes       0.0.0.0:8080->80/tcp   apache-php
50197361e87b        mariadb             "docker-entrypoint..."   2 hours ago         Up 2 hours          3306/tcp             mariadb-container-with-existing-external-volume
6f08ac657320        mariadb             "docker-entrypoint..."   5 hours ago         Up 3 hours          3306/tcp             mariadb-container
```

Sadly before we can link the frontend and backend we have to get rid of the existing containers.

```bash
docker stop apache-php mariadb-container mariadb-container-with-existing-external-volume
docker rm apache-php mariadb-container mariadb-container-with-existing-external-volume
```

To enable the communication between two or more Docker containers you have to use Docker network. Per default there are three networks available:

```bash
docker network ls
```

```
NETWORK ID          NAME                DRIVER              SCOPE
9233283df4a6        bridge              bridge              local
640877f8aec4        host                host                local
72f9a9996909        none                null                local
```

For this exercise we are creating our own network with:
 
```bash
docker network create docker-techlab
```

If you now rerun the list command for Docker networks you should see the newly created network.

To make the backend accessible/visible to the frontend (via Container-NAMES) you have to run both containers with the `--network` option:

```bash
docker run -d --network docker-techlab --name apache-php -v $(pwd)/php-app:/var/www/html -p 8080:80 php:7-apache
docker run -d --network docker-techlab --name mariadb-container-with-existing-external-volume -v volume-mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw mariadb
```

If you now access the containers you should be able to resolve the other's container address with its container name.

``` bash
docker exec -it mariadb-container-with-existing-external-volume bash
root@6f08ac657320:/# getent hosts apache-php
```

Now the two containers can talk to each other. Let's check this:

If you now type <http://localhost:8080/db.php> in your browser you should get... an error!
Because the mysqli extension is not found.

> Question: I don't want to go to the Docker instance and install every missing extension manually. Is there a way to solve this problem?

I'm sure there is, let's check out the next lab to find out how.
