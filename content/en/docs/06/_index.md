---
title: "6. Working with volumes"
weight: 6
---

{{% details title="🤔 I have a container with a database server running. What happens to my data when I remove the container?" %}}
It's gone. The docker instance has no persistence layer to store data permanently, let us address that problem in this chapter.
{{% /details %}}


## Mounting a volume in a container

The MariaDB container is a good example as to why it's good to have an external volume.
There are several possibilities on how to work with volumes in Docker, in this case, we're going to create a docker volume to store the persistent data of our MariaDB. The volume is managed by Docker itself.

Create the docker-managed volume with:

```bash
docker volume create volume-mariadb
```

Now use the created volume and attach it to the MariaDB database.

With the parameter `-v` attach the volume to a path in the container:

```bash
docker run --name mariadb-container-with-external-volume -v volume-mariadb:/var/lib/mysql -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb
```

See [Docker's Volumes documentation](https://docs.docker.com/storage/volumes/) for more information.

Okay, now create a new user in the MariaDB container:

```bash
docker exec -it mariadb-container-with-external-volume mariadb -uroot -pmy-secret-pw
```

Inside the mariadb-client execute some SQL commands:

```bash
use mysql
CREATE USER 'peter'@'%' IDENTIFIED BY 'venkman';
GRANT SELECT ON * . * TO 'peter'@'%';
```

Once all steps are completed quit the mysql session and exit the container:
```bash
exit;
```

To test if Peter has been created correctly, just login using his credentials.

Now stop and remove the `mariadb-container-with-external-volume` container.

```bash
docker stop mariadb-container-with-external-volume
docker rm mariadb-container-with-external-volume
```

Next, check if the data is still available.
Create a new MariaDB container with the previous volume:

```bash
docker run --name mariadb-container-with-existing-external-volume \
            -v volume-mariadb:/var/lib/mysql \
            -e MARIADB_ROOT_PASSWORD=my-secret-pw \
            -d mariadb
```

The moment of truth... Connect to the database server using Peter's credentials:

```bash
docker exec -it mariadb-container-with-existing-external-volume mariadb -upeter -pvenkman
```

You should now be connected to your database instance as `peter`. You can test this by listing the users with the sql client:

```bash
SELECT User FROM mysql.user;
```

```
+-------------+
| User        |
+-------------+
| peter       |
| root        |
| healthcheck |
| healthcheck |
| healthcheck |
| mariadb.sys |
| root        |
+-------------+
7 rows in set (0.001 sec)
```
Now exit the mariadb client

```bash
exit;
```


## Additional info for working with Docker volumes

Docker volumes can be used for:

* Decoupling the data that is stored from the container which created the data
* Bypassing the copy-on-write system to obtain native disk I/O performance
* Bypassing copy-on-write to leave some files out of docker commit
* Sharing a directory between multiple containers
* Sharing a directory between the host and a container
* Sharing a single file between the host and a container
An alternative to working with volumes would be to mount local directories (host folders) by a path into your container. We will use this in chapter 08.


### Docker storage driver

When running a lot of Docker containers on a machine you usually need a lot of storage. Docker volumes and container storage are provided on a filesystem. The following link provides additional information on how to choose the correct storage setup:

<https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html/managing_containers/managing_storage_with_docker_formatted_containers>

At the moment, `overlay2` is the [recommended storage driver](https://docs.docker.com/storage/storagedriver/select-storage-driver/#docker-ce).
