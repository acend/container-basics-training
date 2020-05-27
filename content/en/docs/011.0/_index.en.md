---
title: "11. Building Your Own Docker Image"
weight: 11
---

Previously in the lab...

> Question: I don't want to go to the Docker instance and install every missing extension manually. Is there a way to solve this problem?

Answer: Yes there is. Create your own Dockerfile which describes the content of a Docker image.

## Dockerfile

Docker can build Docker images by reading the instructions on how to build the image from a so called Dockerfile.

The basic docs on how Dockerfiles work can be found at <https://docs.docker.com/engine/reference/builder/>.

## Write Your First Dockerfile

For that we create a new directory and create an empty Dockerfile in there. You can either use vim or the editor of your choice.

```bash
mkdir myfirstimage
cd myfirstimage
vim Dockerfile # or editor of your choice --> close and save file with vim [ESC] :wq!
```

Add the following content to your Dockerfile:

```bash
FROM ubuntu
RUN apt-get update && \
    apt-get install -y figlet && \
    apt-get clean
```

* `FROM` indicates the base image for our build
* Each `RUN` line will be executed by Docker during the build
* Our RUN commands must be non-interactive (no input can be provided to Docker during the build)
* Check <https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/> for further best practices on how to write nice Dockerfiles

## Build the Image

```bash
docker build -t myfirstimage .
```

* `-t` indicates the tag to apply to the image
* `.` indicates the location of the build context (about which we will talk more later but is basically the directory where our Dockerfile is located)

Please note that the tag can be omitted in most Docker commands and instructions. In that case the tag defaults to `latest`. Besides being the default tag there's nothing special about `latest`. Despite its name it does not necessarily identify the latest version of an image.
Depending on the build system it can point to the last image pushed, to the last image built from some branch or to some old image. It can even not exist at all.
Because of this you must never use the `latest` tag in production, always use a specific image version.

Also see: <https://medium.com/@mccode/the-misunderstood-docker-tag-latest-af3babfd6375>

### What Happens When We Build the Image

The output of the Docker build looks like this:

```bash
docker build -t myfirstimage .
```

```
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM ubuntu
 ---> ea4c82dcd15a
Step 2/2 : RUN apt-get update &&     apt-get install -y figlet &&     apt-get clean
 ---> b3c08112fd1c
Successfully built b3c08112fd1c
Successfully tagged myfirstimage:latest
```

(The output of the `run` commands has been omitted).

### Sending the Build Context to Docker

```bash
Sending build context to Docker daemon 84.48 kB
```

* The build context is the `.` directory given to docker build
* It is sent (as an archive) by the Docker client to the Docker daemon
* This allows to use a remote machine to build using local files
* Be careful (or patient) if that directory is big and your link is slow

### Inspecting Step Execution

```bash
docker build -t myfirstimage .
``` 

```
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM ubuntu
 ---> ea4c82dcd15a
Step 2/2 : RUN apt-get update &&     apt-get install -y figlet &&     apt-get clean
 ---> b3c08112fd1c
Successfully built b3c08112fd1c
Successfully tagged myfirstimage:latest
```

* A container (ea4c82dcd15a) is created from the base image
  * The base image will be pulled, if it was not pulled before
* The `RUN` command is executed in this container
* The container is committed into an image (b3c08112fd1c)
* The build container (ea4c82dcd15a) is removed
* The output of this step will be the base image for the next one
* ...

### The Caching System

If you run the same build again, it will be instantaneous.
Why?

* After each build step, Docker takes a snapshot
* Before executing a step, Docker checks if it has already built the same sequence
* Docker uses the exact strings defined in your Dockerfile:
  * `RUN apt-get install figlet cowsay` is different from
  * `RUN apt-get install cowsay figlet`
  * `RUN apt-get update` is not re-executed when the mirrors are updated
* All steps after a modified step are re-executed since the filesystem it's based on may have changed

You can force a rebuild with docker build --no-cache ...

If you only want to trigger a partial rebuild, e.g. run `apt-get update` to install the latest updates,
you can use the following pattern:

```bash
ENV REFRESHED_AT 2020-03-13
RUN apt-get update
```

If you update the value of REFRESHED_AT it will invalidate the Docker build cache of that and all
the following steps, thus installing the latest updates.

### Run It

```bash
docker run -ti myfirstimage
```

```
root@00f0766080ed:/# figlet hello
 _          _ _
| |__   ___| | | ___
| '_ \ / _ \ | |/ _ \
| | | |  __/ | | (_) |
|_| |_|\___|_|_|\___/

root@00f0766080ed:/#
```

## The `CMD` Instruction in Dockerfile

With the `CMD` instruction in the Dockerfile we have the possibility to define the command that is executed by default if a container is started:

```bash
FROM ubuntu
RUN apt-get update
RUN apt-get install -y figlet

CMD ["figlet", "hello"]
```

After building the image with `docker build -t myfirstimagecmd .`, we simply run it:

```bash
docker run -ti myfirstimagecmd
```

It directly executes the defined command and prints out

```bash
 _          _ _
| |__   ___| | | ___
| '_ \ / _ \ | |/ _ \
| | | |  __/ | | (_) |
|_| |_|\___|_|_|\___/


```

Checkout <https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact> for more information.

## Frontend App Image Build

We now want to include the source code of our frontend app into a built docker image, so we use the Dockerfile within this lab.

The base image is our php:7-apache image which we used before. The `ADD` command allows us to add files from our current directory into the Docker image.
We use this command to add the application source code into the image.

**Hint**: Use `.dockerignore` to exclude files from the Docker context being added to the container. It works the same as `.gitignore`: <https://docs.docker.com/engine/reference/builder/#dockerignore-file>

```bash
FROM php:7-apache

# Copies the php source code to the correct location
ADD ./php-app/ /var/www/html/

# Install additional php extension
RUN docker-php-ext-install mysqli
```

**Note**: The `docker-php-ext-install` command will most probably not be able to download the required dependencies if there's a proxy in the way. In this case you can use the already built image `puzzle/php-apache-mysqli` for the following labs. Instead of above Dockerfile you'd use:

```bash
FROM puzzle/php-apache-mysqli

# Copies the php source code to the correct location
ADD ./php-app/ /var/www/html/
```


### Build the php-app Image

**Note**: Stop and delete the running php-app container first. Leave the database container running.

If you're not still inside the php-app directory, now's the time to change into it. Let's build the image:

```bash
docker build -t php-app .
```


### Run the php-app Container

```bash
docker run -d --network docker-techlab --name php-app -p8080:80 php-app
```

Now open a browser and navigate to <http://localhost:8080/db.php>.
You should get a response saying "Connected successfully".

## Additional Lab

Configuration should always be separate from the source code, so the database connection details must not be inside the php file `db.php`.
Fix the code in the db.php file. According to the continuous delivery principles we don't want usernames and passwords in our source code.

**Hint**: Use the PHP function `getenv("WHAT_EVER_KEY")` to read config values from environment variables inside the frontend container. You might want to use the `-e` parameter to set an environment variable inside a container while running it (`docker run -e`).
