---
title: "12. Debugging Running Container"
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

## List Containers

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

To see the general docker storage usage(After 1.13.0, Docker):

```bash
docker system df
```

This is helpful for scripting or doing a lot of experimentation where you start and delete quite a lot of times a container. As an example `docker rm -f $(docker ps -ql)`, which will delete the last started container.

## Stopping Containers

Take a look at [Lab 04](../04.0).

## Restarting and Attaching to Containers

We have started containers in the foreground, and in the background.
Now we will see how to:

* Put a container in the background.
* Attach to a background container to bring it to the foreground.
* Restart a stopped container

### Background and Foreground

From Docker's point of view, all containers are the same. All containers run the same way, whether there is a client attached to them or not.

It is always possible to detach from a container, and to re-attach to a container.

### Detaching from a Container

If you have started an interactive container (with option -it), you can detach from it.

* The "detach" sequence is `^P^Q`.
* Or you can detach by killing the Docker client.

Don’t hit `^C`, as this would deliver SIGINT to the container

What does -it stand for?

* `-t` means "terminal" as in "allocate a terminal."
* `-i` means "interactive" as in "connect stdin to the terminal."

### Attaching to a Container

You can attach to a container:

```bash
docker attach <containerID|name>
```

* The container must be running.
* There can be multiple clients attached to the same container.
* Warning: if the container was started without -it…
  * You won't be able to detach with ^P^Q.
  * If you hit ^C, the signal will be proxied to the container.

Remember: you can always detach by killing the Docker client (e.g. close the bash window).

### Executing a Command in a Container

You can execute a command in a container:

```bash
docker exec -i -t <containerID|name> <command>
```

E.g. if you want to execute a shell, then run the following command:

```bash
docker exec -i -t <containerID|name> /bin/bash
```

### Checking Container Output

Use `docker attach` if you intend to send input to the container.
If you just want to see the output of a container, use docker logs

### Restarting a Container

When a container has exited, it is in stopped state.

* It can then be restarted with the start command: `docker start <yourContainerID>`

The container will be restarted using the same options you launched it with.
You can re-attach to it if you want to interact with it

## Listing Images

We already stumbled about the command to list Docker images. See [Lab 02](02_images.md).

## Viewing Logs of Containers

```bash
docker logs <CONTAINER ID>
```

This will show the whole log of that container, sometimes it's enough to display only a few lines:

```bash
docker logs --tail 3 <CONTAINER ID>
```

With the `-follow` option you can tell the `docker logs` command to follow the log file in real time:

```bash
docker logs --tail 3 --follow <CONTAINER ID>
```

## House Keeping

Keep your local dev environment clean. And 

**Don't run in production environment!!!**

### Stop All Running Containers

```bash
docker stop $(docker ps -a -q)
```

### Delete All Containers

```bash
docker rm $(docker ps -a -q)
```

### Delete All Images

```bash
docker rmi $(docker images -q)
```

### Docker prune

you can use the `docker system prune` command to keep your production environment clean