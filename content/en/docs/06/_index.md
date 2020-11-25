---
title: "6. Names"
weight: 6
---

From the [previous lab](../05/):

> Question: Where do these strange names come from?

Answer: Docker (what a surprise!)... Beside the CONTAINER_ID the NAME is a unique identifier for a container.


## Naming a container

Unlike the CONTAINER_ID the NAME is something we can manipulate. The name is handy not only for starting/connecting/stopping/destroying a container but also for the networking (which comes later in the lab).

To do so, you have to add a parameter in the `run` command of Docker

```bash
docker run --name mariadb-container -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb
```

As always, to check if this has really worked out look at the container list

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
6f08ac657320        mariadb             "docker-entrypoint..."   58 seconds ago      Up 57 seconds       3306/tcp            mariadb-container
699e82ed8f1f        mariadb             "docker-entrypoint..."   24 minutes ago      Up 24 minutes       3306/tcp            jolly_bardeen
```

If you want to access your DB server there are two ways:

1) Using `docker exec -it mariadb-container bash`
   This will connect you into the remote `bash` shell from where you can connect to the server via `mysql -uroot -pmy-secret-pw`.

1) Using a local mysqlclient
   This is a bit tricky. First you have to find out the IP address of your docker container. Therefore, use this command:

```bash
docker inspect mariadb-container
```

```
[
    {
        "Id": "6f08ac657320f279a9193728905f6f18d74f72d2c5dea97a9ffc76fb7e216c59",
        "Created": "2020-05-27T06:37:18.180716875Z",
        "Path": "docker-entrypoint.sh",
        "Args": [
            "mysqld"
        ],

...

        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "5a244dfe119b4211326ae2afb7b4331cba026df3b9b0b535c619606a8fd68a61",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "3306/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/5a244dfe119b",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "6dcdf9ed5c90c9fbf5eee5253a7642efff861603c079b0cba17111cb5c3e2514",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "4b12e50d081a1d103918e742503b0d52f05c50daf35c4d07d3bd7cd53fe75a79",
                    "EndpointID": "6dcdf9ed5c90c9fbf5eee5253a7642efff861603c079b0cba17111cb5c3e2514",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
```

In the last section (`NetworkSettings`) you will find the `IPAddress` for your container. In this example it's 172.17.0.2.
Once you have the IP you can connect with the command `mysql -h172.17.0.2 -uroot -p` (use password from run command)

{{% alert title="Note" color="primary" %}}
The mysql client must be installed on your computer. On Windows, you can use the binary from the ZIP archive at <https://dev.mysql.com/downloads/mysql/>.

Also on Windows you must use port-forwarding to access the database:

```bash
docker run --name mariadb-container -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb
```

Now you should be able to access the database by: `winpty mysql.exe -hlocalhost -uroot -p`.
{{% /alert %}}

> Question: I have a container with a database server running. When I remove the container, what happens to my data?

Let's find out in the [next lab](../07/)!
