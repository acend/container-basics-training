---
title: "9. Embedding the Source Code"
weight: 9
---

Previously in the lab...

Question: Why? Why do I get this error? And is there no other way to access the webserver via the private IP?

Answer(s):

1. The apache webserver does not allow to scan its own document root.
2. There is another way, and you're going to love it.

## Get the PHP App

For this lab you're going to need a small PHP app consisting of two files.

First, let's create a directory for the app's files called `php-app`.

Then, inside that directory, create a new file named `index.php` with the following content:

```php
<?php
echo "Welcome to Docker (my young padawan)!";
```

**Note for play-with-docker.com:**

* create directory with this shell command: `mkdir php-app`
* create file with this shell command: `touch index.php`
* open your editor
* select the folder and then the file
* add the content and save the changes

And lastly, create another file named `db.php` with the following content:

```php
<?php
$servername = "mariadb-container-with-existing-external-volume";
$username = "peter";
$password = "venkman";

// Create connection
$conn = new \mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully";
```

That's it for the app part.

## Mounting the dev environment into your Docker container

Make sure you're outside that freshly created app directory when you execute the next commands.

Now you can mount the php-app as host directory into your docker container via

**Tipp:** you need to set the absolute path on the -v option eg. `-v /home/[path]/php-app` `-v c:/temp/php-app:/var/www/html`

```bash
docker run -d --name apache-php -v /home/[path]/php-app:/var/www/html  php:7-apache
```

**Note:** Do not forget to stop/remove the existing instance of the apache-php container before you start a new one.

You can now check if the error is still present OR you wait until the second question is answered.

## Portforwarding your Docker Container

Docker is able to forward any port you want/specify to your local machine. This is great but also has the possibility of causing port trouble.
Imagine you had a local httpd service running on port 80 and you are forwarding this same port to your Docker instance.

But let's not assume this right now! Or simply use a port other than 80.

As you might have guessed it's again a parameter named `-p[local]:[container]` that you can set:

```bash
docker run -it --name apache-php -v /home/[path]/php-app:/var/www/html -p8080:80 php:7-apache
```

**Note:** Do not forget to stop/remove the existing instance of the apache-php container before you start a new one.

If you take a look into `docker container ls` you'll find an interesting change for the PORT column

```bash
docker container ls
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
6b0721fa6103        php:7-apache        "docker-php-entryp..."   5 seconds ago       Up 4 seconds        0.0.0.0:8080->80/tcp   apache-php
50197361e87b        mariadb             "docker-entrypoint..."   2 hours ago         Up 2 hours          3306/tcp             mariadb-container-with-existing-external-volume
6f08ac657320        mariadb             "docker-entrypoint..."   5 hours ago         Up 2 hours          3306/tcp             mariadb-container
```

You see that every request coming to port 8080 on your local machine is forwarded to your Docker instance's port 80.
If you now type <http://localhost:8080/index.php> in your browser you should get the message: "Welcome to Docker...".

**Note for play-with-docker.com:** To access the frontend app, you have to use a special url.

* copy the ssh connection command (`ssh ip172-18-0-30-bcvhrp0abk8g00cnf9jg@direct.labs.play-with-docker.com`)
* remove *ssh* and replace the **@** with a **.**
* with that url you will see the app page: `ip172-18-0-30-bcvhrp0abk8g00cnf9jg.direct.labs.play-with-docker.com`

Question: Can I somehow link the containers together so they can talk to each other?

The answer lies in the next lab.