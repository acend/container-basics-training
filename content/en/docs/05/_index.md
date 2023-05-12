---
title: "5. Names"
weight: 5
---

## Naming a container

Unlike the `CONTAINER ID`, the `NAME` is something we can manipulate. The name is handy, not only for starting/connecting/stopping/destroying a container, but also for networking (which we will see in a later lab).

To set a name, add the `--name` parameter to Docker's `run` command:

```bash
docker run --name mariadb-container -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb
```

As always, to check if this has really worked out, look at the container list:

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
6f08ac657320        mariadb             "docker-entrypoint..."   58 seconds ago      Up 57 seconds       3306/tcp            mariadb-container
699e82ed8f1f        mariadb             "docker-entrypoint..."   24 minutes ago      Up 24 minutes       3306/tcp            jolly_bardeen
```

Instead of accessing the database from inside the container like in the last lab, we access it from outside using a local mysqlclient.

This is a bit tricky. First find out the IP address of your docker container. Therefore, use this command:

```bash
docker inspect mariadb-container  -f '{{ range.NetworkSettings.Networks }}{{ .IPAddress }}{{ end }}'
```

`docker inspect <container>` shows you details about a running container in JSON format (run it yourself and take a look at it). We filtered the json to only get the IP address of the container.  
We could also have filtered the output with grep: `docker inspect mariadb-container | grep IPAddress` but our solution is more elegant 😊.

Once you have the IP (in your example `172.17.0.2`) connect to it:

```bash
mysql -h172.17.0.2 -uroot -p my-secret-pw` 
```
If everthings works, exit mysql-client

```bash
exit;
```


{{% alert title="Note for Windows" color="primary" %}}
The mysql client must be installed on your computer. On Windows, you can use the binary from the ZIP archive at <https://dev.mysql.com/downloads/mysql/>.

Also on Windows, you must use port-forwarding to access the database:

```bash
docker run --name mariadb-container -p 3306:3306 -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb
```

Now you should be able to access the database with:

```bash
winpty mysql.exe -hlocalhost -uroot -pmy-secret-pw
```

{{% /alert %}}

{{% details title="🤔 Can you imagine another way to access the database?" %}}
Instead of entering the container with bash, we could also directly run mysql inside the container:
`docker exec -it mariadb-container mysql -uroot -pmy-secret-pw`
{{% /details %}}
