---
title: "6. Working with volumes"
weight: 6
---

From the [previous lab](../05/):

> Question: I have a container with a database server running. What happens to my data when I remove the container?

Answer: It's gone. The docker instance has no persistence layer to store data permanently but (as always) there are parameters to set, so you can store your data outside of the container.


## Mounting a volume in a container

The MariaDB container is a good example as to why it's good to have an external volume.
There are several possibilities on how to work with volumes in Docker, in this case, we're going to create a docker volume to store the persistent data of our MariaDB. The volume is managed by Docker itself.

Create the docker managed volume with:

```bash
docker volume create volume-mariadb
```

Now let's use the created volume and attach it to the MariaDB database.

With the parameter `-v` you can now state where to attach the volume, e.g.:

```bash
docker run --name mariadb-container-with-external-volume -v volume-mariadb:/var/lib/mysql -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb
```

See [Docker's Volumes documentation](https://docs.docker.com/storage/volumes/) for further information.

Okay, let's create a new user in the MariaDB container:

1. `docker exec -it mariadb-container-with-external-volume bash`
2. `mysql -uroot -pmy-secret-pw`
3. In the mysql-client:

```bash
use mysql
CREATE USER 'peter'@'%' IDENTIFIED BY 'venkman';
GRANT SELECT ON * . * TO 'peter'@'%';
```

Once all steps are completed you can quit(`exit;`) the mysql session and exit the container(`crtl d`). (If you want to test if peter has been created correctly just login using his credentials).

Now we have to stop and remove the `mariadb-container-with-external-volume` container.

```bash
docker stop mariadb-container-with-external-volume
docker rm mariadb-container-with-external-volume
```

It's getting interesting...
We are creating a new MariaDB container with the data storage volume:

```bash
docker run --name mariadb-container-with-existing-external-volume -v volume-mariadb:/var/lib/mysql -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb
```

The moment of truth... Connect to the database server:

```bash
docker exec -it mariadb-container-with-existing-external-volume bash
```

```bash
mysql -upeter -pvenkman
```

If everything worked as expected, you should now be connected to your database instance as peter. You can test this by using the `SELECT User FROM mysql.user;` statement in the sql client.

```bash
SELECT User FROM mysql.user;
```

```
+-----------------+
| USER()          |
+-----------------+
| peter@localhost |
+-----------------+
1 row in set (0.00 sec)
```

> Question: I'm feeling like a Docker king/queen... What's next?

See [next lab](../07/).


## Additional info for working with Docker volumes

An alternative way of working with volumes, besides mounting local directories (host folders) by a path into your container, is by using Docker volumes.

Docker volumes can be used for:

* Decoupling the data that is stored from the container which created the data
* Bypassing the copy-on-write system to obtain native disk I/O performance
* Bypassing copy-on-write to leave some files out of docker commit
* Sharing a directory between multiple containers
* Sharing a directory between the host and a container
* Sharing a single file between the host and a container


### Docker storage driver

When running a lot of Docker containers on a machine you usually need a lot of storage. Docker volumes and container storage are provided on a filesystem. The following link provides additional information on how to choose the correct storage setup:

<https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html/managing_containers/managing_storage_with_docker_formatted_containers>

At the moment, `overlay2` is the [recommended storage driver](https://docs.docker.com/storage/storagedriver/select-storage-driver/#docker-ce).
