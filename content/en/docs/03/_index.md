---
title: "3. Environment variables"
weight: 3
---

## Environment variables

What happened?
The MariaDB server is not able to run without a proper configuration. Docker can pass variables into the instantiation process via environment variables.
Environment variables are passed via the parameter `-e` e.g.:

```bash
docker run -it -e MARIADB_ROOT_PASSWORD=my-secret-pw mariadb
```

Once you run the command you will see an output like this:

```

Initializing database

PLEASE REMEMBER TO SET A PASSWORD FOR THE MariaDB root USER !
To do so, start the server, then issue the following commands:

'/usr/bin/mysqladmin' -u root password 'new-password'
'/usr/bin/mysqladmin' -u root -h  password 'new-password'

Alternatively you can run:
'/usr/bin/mysql_secure_installation'

which will also give you the option of removing the test
databases and anonymous user created by default.  This is
strongly recommended for production servers.

See the MariaDB Knowledgebase at http://mariadb.com/kb or the
MySQL manual for more instructions.

Please report any problems at http://mariadb.org/jira

The latest information about MariaDB is available at http://mariadb.org/.
You can find additional information about the MySQL part at:
http://dev.mysql.com
Consider joining MariaDB's strong and vibrant community:
https://mariadb.org/get-involved/

Database initialized
MySQL init process in progress...
2020-05-27  6:21:03 0 [Note] mysqld (mysqld 10.3.7-MariaDB-1:10.3.7+maria~jessie) starting as process 101 ...
2020-05-27  6:21:03 0 [Note] InnoDB: Using Linux native AIO
2020-05-27  6:21:03 0 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
2020-05-27  6:21:03 0 [Note] InnoDB: Uses event mutexes
2020-05-27  6:21:03 0 [Note] InnoDB: Compressed tables use zlib 1.2.8
2020-05-27  6:21:03 0 [Note] InnoDB: Number of pools: 1
2020-05-27  6:21:03 0 [Note] InnoDB: Using SSE2 crc32 instructions
2020-05-27  6:21:03 0 [Note] InnoDB: Initializing buffer pool, total size = 256M, instances = 1, chunk size = 128M

...

2020-05-27  6:21:08 0 [Note] mysqld: ready for connections.
Version: '10.3.7-MariaDB-1:10.3.7+maria~jessie'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  mariadb.org binary distribution
```

If you re-read the command above you will notify, that we used the arguments -it (interactive/detached). And you might have found out that mariadb does not react to the usual `CTRL-c`.
So how do we exit this terminal? Docker has an escape sequence to detach from a container and leave it running. For this you have to press `CTRL-p` and then `CTRL-q` in bash.

{{% alert title="Note for Webshell" color="primary" %}}
In the webshell the shortcuts `CTRL-p` and `CTRL-q` are not working. Simply close the terminal and open a new one as a workaround. You could also start your mariadb container with `docker run -dit -e MARIADB_ROOT_PASSWORD=my-secret-pw mariadb`, note the `d` in `-dit` which starts the container in detached mode. Afterward, you can open a shell into the detached container as described below.
{{% /alert %}}

{{% alert title="Note for Windows" color="primary" %}}
This might not work on Windows since the shortcuts `CTRL-p` and `CTRL-q` are already used for other purposes. Use `docker ps` in a separate shell to get the container ID and then stop it using `docker stop <container>`. After that, you have to restart the container with `docker start <container>` or start a new container with `docker run -d ...` as described in the section _Detached_ below.
{{% /alert %}}

This will leave the container running while you are back in your shell. To verify that the container is running use the following command:

```bash
docker ps
```

The output should look much like this:

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
7cb31f821233        mariadb             "docker-entrypoint..."   5 minutes ago       Up 5 minutes        3306/tcp            upbeat_blackwell
```

To connect to the container again you can use the following command:

```bash
docker exec -it <container> bash
```

Where `<container>` can refer to the `CONTAINER ID` (the first two characters are normally sufficient) or one of the `NAMES` from the output of `docker ps`.

{{% alert title="Note" color="primary" %}}
The docker exec command needs either the ID or NAME of the container. Additionally, at the end, an executable.
{{% /alert %}}

In this example, it's `bash` as we want to do something interactively in the container.

Once the command is executed you should see this:

`root@7cb31f821233:/#`

{{% alert title="Note" color="primary" %}}
Every time you connect yourself to a container you will always be the user that was defined in the Dockerfile.
{{% /alert %}}

Now that we are connected let's find out if the MariaDB is working...

```bash
mysql -uroot -pmy-secret-pw
```

If everything works as expected, you should now see the MariaDB command line:

```
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 10.3.8-MariaDB-1:10.3.8+maria~jessie mariadb.org binary distribution

Copyright (c) 2000, 2020, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```

Type `exit` to leave the mysql client. Type `exit` one more time to leave the container.


## Detached

One might think: _This whole starting process is a bit cumbersome with `CTRL-p` and then `CTRL-q`_.
Therefore, you can run a Docker container directly run with -d "detached" mode e.g.:

```bash
docker run -it -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb
```

Instead of the output of the container itself you will now only get the ID of the started container.
If you have a look into the container list, you should see two running containers:

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
699e82ed8f1f        mariadb             "docker-entrypoint..."   3 minutes ago       Up 3 minutes        3306/tcp            jolly_bardeen
7cb31f821233        mariadb             "docker-entrypoint..."   32 minutes ago      Up 32 minutes       3306/tcp            upbeat_blackwell
```


{{% details title="Question: Do we need two running MariaDB containers at the same time for this lab?" %}}
Answer: No!

So let’s delete a container in the [next lab](../04/).

{{% /details %}}
