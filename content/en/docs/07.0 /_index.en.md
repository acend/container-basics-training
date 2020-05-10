---
title: "7. Working with Volumes"
weight: 7
---

Previously in the lab...

> Question: I have a container with a database server running. But when I remove the container, what happens to my data?

Answer: It's gone. The docker instance has no persistence layer to store data permanently but (as always) there are parameters to set so you can store your data outside of the container.

## Mounting a Volume in a Container

The mariadb container is fortunately a good example as to why it's good to have an external volume.
There are several possibilities on how to work with volumes on docker, in this case, we're going to create a docker volume, that is managed by docker itself.

**Lab:** Checkout [Docker's Volumes documentation](https://docs.docker.com/storage/volumes/#choose-the--v-or---mount-flag) and create a Docker volume for your mariadb container to store the persistent data on it.

Create the docker managed volume with:
```bash
docker volume create volume-mariadb
```

Now let's use the created volume and attach it to the mariadb database.

With the parameter `-v` you can now state where to attach the volume, e.g.:

```bash
docker run --name mariadb-container-with-external-volume -v volume-mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb
```

### Using a host directory as volume 

We need to create a directory named `datastore-mariadb` but don't change into it (shell command: `mkdir datastore-mariadb`).

**Hint:** The local path as volume sometimes needs an additional configuration parameter on Windows due to the storage driver setup. See below for more information.


```bash
docker run --name mariadb-container-with-path-volume -v /[absolute path to your directory]/datastore-mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb
```

As mentioned in the hint above, add the following configuration parameter __on Windows__ to the basic `docker run` command. :

```bash
--innodb_flush_method=O_DSYNC
```

Powershell:

```bash
docker run --name mariadb-container-with-path-volume -v C:\...\datastore-mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb --innodb_flush_method=O_DSYNC
```

Windows bash:

```bash
docker run --name mariadb-container-with-path-volume -v //c/.../datastore-mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb --innodb_flush_method=O_DSYNC
```

Once the container is up and running let's have a look into the datastore directory:

**Hint:** use `dir` instead of `ls -la` on Windows

```bash
ls -la datastore-mariadb/
```

```
total 122944
drwxrwxr-x 4 guest-r0bhvk docker     4096 Mai 31 08:50 .
drwxrwxr-x 5 user         user       4096 Mai 31 08:49 ..
-rw-rw---- 1 guest-r0bhvk docker    16384 Mai 31 08:50 aria_log.00000001
-rw-rw---- 1 guest-r0bhvk docker       52 Mai 31 08:50 aria_log_control
-rw-rw---- 1 guest-r0bhvk docker      976 Mai 31 08:50 ib_buffer_pool
-rw-rw---- 1 guest-r0bhvk docker 12582912 Mai 31 08:50 ibdata1
-rw-rw---- 1 guest-r0bhvk docker 50331648 Mai 31 08:50 ib_logfile0
-rw-rw---- 1 guest-r0bhvk docker 50331648 Mai 31 08:50 ib_logfile1
-rw-rw---- 1 guest-r0bhvk docker 12582912 Mai 31 08:50 ibtmp1
-rw-rw---- 1 guest-r0bhvk docker        0 Mai 31 08:50 multi-master.info
drwx------ 2 guest-r0bhvk docker     4096 Mai 31 08:50 mysql
drwx------ 2 guest-r0bhvk docker     4096 Mai 31 08:50 performance_schema
-rw-rw---- 1 guest-r0bhvk docker    24576 Mai 31 08:50 tc.log
```

Okay, let's create a new user in the mariadb container:

1. `docker exec -it mariadb-container-with-external-volume bash`
2. `mysql -uroot -pmy-secret-pw`
3. In the mysql-client: `use mysql`
4. In the mysql-client: `CREATE USER 'peter'@'%' IDENTIFIED BY 'venkman';`

Once all steps are done you can quit(`exit;`) the mysql session and exit the container(`crtl d`). (If you want to test if peter has been created correctly just login using his credentials).

Now we have to stop and remove the mariadb-container-with-external-volume container.

```bash
docker stop mariadb-container-with-external-volume
docker rm mariadb-container-with-external-volume
```

It's getting interesting...
We are creating a new mariadb container with the datastorage volume:

```bash
docker run --name mariadb-container-with-existing-external-volume -v volume-mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb
```

The moment of truth... Connect to the database server:

```bash
docker exec -it mariadb-container-with-existing-external-volume bash
``` 

```
root@6f08ac657320:/# mysql -upeter -pvenkman
```

If everything worked as expected you should now have been connected as peter to your database instance. You can test this by using the `SELECT USER();` statement in the sql client.

```bash
SELECT USER();
```

```
+-----------------+
| USER()          |
+-----------------+
| peter@localhost |
+-----------------+
1 row in set (0.00 sec)
```

Question: I'm feeling like a docker king... What's next?

## Additional Info Working With Docker Volumes

An alternative way of working with volumes besides mounting local directories (host folders) by path into your container is by using Docker volumes.

Docker volumes can be used:

* Decouple the data that is stored from the container which created the data
* Bypassing the copy-on-write system to obtain native disk I/O performance
* Bypassing copy-on-write to leave some files out of docker commit
* Sharing a directory between multiple containers
* Sharing a directory between the host and a container
* Sharing a single file between the host and a container

### Docker Storage Driver

When running a lot of Docker containers on a machine usually a lot of storage is needed. Docker volumes and container storage are provided on a filesystem. The following link provides additional information on how to choose the correct storage setup:

<https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html/managing_containers/managing_storage_with_docker_formatted_containers>

At the moment, `overlay2` is the [recommended storage driver](https://docs.docker.com/storage/storagedriver/select-storage-driver/#docker-ce).

**Lab:** Checkout [Docker's Volumes documentation](https://docs.docker.com/storage/volumes/#choose-the--v-or---mount-flag) and create a Docker volume for your mariadb container to store the persistent data on it.

**Hint:** Use `docker volume create <name>` and `docker run -v <name>:<path> …` commands.