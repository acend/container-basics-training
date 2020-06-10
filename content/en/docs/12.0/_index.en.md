---
title: "12. Debugging running containers"
weight: 12
---

In this Lab you'll learn some more advanced features used when debugging, stopping and starting containers


## Docker info

To see general info about your docker environment use

```bash
docker system info
```

```
Containers: 42
 Running: 0
 Paused: 0
 Stopped: 42
Images: 75
Server Version: 18.06.1-ce
Storage Driver: overlay2
 Backing Filesystem: extfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file logentries splunk syslog
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Init Binary: docker-init
containerd version: 468a545b9edcd5932818eb9de8e72413e616e86e
runc version: 69663f0bd4b60df09991c08812a60108003fa340
init version: fec3683
Security Options:
 apparmor
 seccomp
  Profile: default
Kernel Version: 4.15.0-36-generic
Operating System: Ubuntu 18.04.1 LTS
OSType: linux
Architecture: x86_64
CPUs: 4
Total Memory: 15.31GiB
Name: system-name
ID: QSH5:AZKW:AZKW:FZLG:AZKW:2WRM:AZKW:OOFU:UUTI:AZKW:YBG5:QI4F
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Username: philipona
Registry: https://index.docker.io/v1/
Labels:
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false

```


## Listing containers

{{% alert title="Hint" color="info" %}}
`docker ps` and `docker container ls` are equivalent. This also applies to other top-level commands.

For brevity, we are going to use `docker ps` etc. even though the `docker container` commands are more consistent.
See `docker container --help` for a full list of sub-commands.
{{% /alert %}}

To see all running containers:

```bash
docker ps
```

To see all containers, also exited containers:

```bash
docker ps --all
```

To see only the last container that was started:

```bash
docker ps -l
```

To see only the ID of containers:

```bash
docker ps -q
```

To see only the ID of the last started container:

```bash
docker ps -ql
```

To see the size of the containers:

```bash
docker ps -s
```

To see the general docker storage usage:

```bash
docker system df
```

This is helpful for scripting or doing a lot of experimentation where you start and delete quite a lot of times a container. As an example `docker rm -f $(docker ps -ql)`, which will delete the last started container.


## Stopping containers

Take a look at [Lab 05](../05.0).


## Restarting and attaching to containers

We have started containers in the foreground, and in the background.
Now we will see how to:

* Put a container in the background.
* Attach to a background container to bring it to the foreground.
* Restart a stopped container


### Background and foreground

From Docker's point of view, all containers are the same. All containers run the same way, whether there is a client attached to them or not.

It is always possible to detach from a container, and to re-attach to a container.


### Detaching from a container

If you have started an interactive container (with option -it), you can detach from it.

* The detach key sequence is `CTRL-p CTRL-q`.
* Or you can detach by killing the Docker client.

Don’t hit `CTRL-c`, as this would deliver SIGINT to the container

What does `-it` stand for?

* `-t` means "terminal" as in "allocate a terminal."
* `-i` means "interactive" as in "connect stdin to the terminal."


### Attaching to a container

You can attach to a container:

```bash
docker attach <container>
```

* The container must be running.
* There can be multiple clients attached to the same container.
* Warning: if the container was started without `-it`:
  * You won't be able to detach with `CTRL-p CTRL-q`.
  * If you hit `CTRL-c`, the signal will be proxied to the container.

Remember: you can always detach by killing the Docker client (e.g. close the bash window).


### Executing a command in a container

You can execute a command in a container:

```bash
docker exec -it <container>
```

E.g. if you want to execute a shell, then run the following command:

```bash
docker exec -it <container> /bin/bash
```


### Checking container output

Use `docker attach` if you intend to send input to the container.
If you just want to see the output of a container, use `docker logs`.


### Restarting a container

When a container has exited, it is in stopped state. It can then be restarted with the start command: `docker start <container>`

The container will be restarted using the same options you launched it with.
You can re-attach to it if you want to interact with it.


## Listing images

We already stumbled about the command to list Docker images. See [Lab 02](../02.0/).


## Viewing logs of containers

```bash
docker logs <container>
```

This will show the whole log of that container, sometimes it's enough to display only a few lines:

```bash
docker logs --tail 3 <container>
```

With the `-follow` option you can tell the `docker logs` command to follow the log file in real time:

```bash
docker logs --tail 3 --follow <container>
```


## Housekeeping

There are various housekeeping commands.


### Dev environment

{{% alert title="Note" color="warning" %}}
Don't use these commands in production!
{{% /alert %}}


Stop all running containers and then delete them:

```bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```

Delete all images:

```bash
docker rmi $(docker images -q)
```


### Pruning

Remove unused data:

```bash
docker system prune
```

Remove all stopped containers:

```bash
docker container prune
```

Remove unused images:

```bash
docker image prune
```
