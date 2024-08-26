---
title: "8. Embedding the source code"
weight: 8
---

It looks like the apache image is working but needs a website to display. Create a small web application and run it inside the container.


## Create a PHP app

For this lab you're going to need a small PHP app consisting of two files.

First, create a directory for the app's files called `php-app`.

Then, inside that directory, create a new file named `index.php` with the following content:

```php
<?php
echo "Welcome to Docker (my young padawan)!";
?>
```

{{% alert title="Note for play-with-docker.com" color="primary" %}}

* Create a directory with this shell command: `mkdir php-app`
* Create a file with this shell command: `touch index.php`
* Open your editor
* Select the folder and then the file
* Add the content and save the changes
{{% /alert %}}

Lastly, create another file named `db.php` with the following content:

```php
<?php
$servername = "mariadb-container-with-existing-external-volume";
$username = "peter";
$password = "venkman";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully";
?>
```

That's it for the app part.


## Mounting the dev environment into your Docker container

Make sure you're outside that freshly created app directory when you execute the next commands.

Now mount the php-app as the host directory into your container:

Linux:

```bash
docker run -d --name apache-php -v $(pwd)/php-app:/var/www/html php:8-apache
```

Windows (Git Bash):

```bash
MSYS_NO_PATHCONV=1 docker run -d --name apache-php -v $(pwd)/php-app/:/var/www/html php:8-apache
```

{{% alert title="Note" color="primary" %}}
You need to set the absolute path on the -v option, e.g. `-v /home/<username>/php-app:/var/www/html` or `-v C:\Temp\php-app:/var/www/html`
{{% /alert %}}

You can now check whether the error is still present.


## Port forwarding for your Docker container

Docker is able to forward any port you specify to your local machine by using `-p <host-port>:<container-port>`.
This is great but also has the possibility of causing port trouble.

Imagine you have a local httpd service running on port 8080, and you are forwarding this same port to your Docker instance.

So first, let us check out if port 8080 is occupied:

In Linux or macOS do the following:

```bash
lsof -i:8080
```

or in Windows (Git Bash):

```bash
netstat -aon | findstr :8080 | findstr LISTENING
```

If you get an output, this means port 8080 is used. In that case just us a different port, like 8888, in the examples below.

Now run the image using the `-p` flag:

Linux/Webshell:

```bash
docker stop apache-php
docker rm apache-php
docker run -p 8080:80 -d --name apache-php -v $(pwd)/php-app:/var/www/html php:8-apache
```

Windows (Git Bash):

```bash
docker stop apache-php
docker rm apache-php
MSYS_NO_PATHCONV=1 docker run -p 8080:80 -d --name apache-php -v $(pwd)/php-app/:/var/www/html php:8-apache
```

{{% alert title="Note regarding the webshell" color="primary" %}}
Do not forget to stop/remove the existing instance of the `apache-php` container before you start a new one.
{{% /alert %}}

If you take a look into `docker ps` you'll find an interesting change for the PORTS column

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
6b0721fa6103        php:8-apache        "docker-php-entryp..."   5 seconds ago       Up 4 seconds        0.0.0.0:8080->80/tcp   apache-php
50197361e87b        mariadb             "docker-entrypoint..."   2 hours ago         Up 2 hours          3306/tcp             mariadb-container-with-existing-external-volume
```

You see that every request coming to port 8080 on your local machine is forwarded to your Docker instance's port 80.
If you now type <http://LOCALHOST:8080/index.php> in your browser you should get the message:  
"Welcome to Docker...".  
<http://LOCALHOST:8080/db.php> will produce an error. This is on purpose. Please be patient until the end of lab 10!

{{% alert title="Note regarding the Webshell" color="primary" %}}

* Instead of the browser use `curl http://LOCALHOST:8080/index.php`.
{{% /alert %}}

{{% alert title="Note for play-with-docker.com" color="primary" %}}
To access the frontend app use a special URL

* Copy the SSH connection command (`ssh ip172-18-0-30-bcvhrp0abk8g00cnf9jg@direct.labs.play-with-docker.com`)
* Remove *ssh* and replace the **@** with a **.**
* With that URL you will see the app page: `ip172-18-0-30-bcvhrp0abk8g00cnf9jg.direct.labs.play-with-docker.com`
{{% /alert %}}
We have succeded in running our own app inside a container 🎉.
