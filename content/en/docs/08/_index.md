---
title: "8. Embedding the source code"
weight: 8
---

From the [previous lab](../07/):

> Question: Why? Why do I get this error? Is there no other way to access the web server via private IP?

Answer(s):

1. The Apache web server does not allow you to scan its own document root.
2. There is another way, and you're going to love it.


## Get the PHP app

For this lab you're going to need a small PHP app consisting of two files.

First, let's create a directory for the app's files called `php-app`.

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

Now you can mount the php-app as the host directory into your docker container via

Linux:

{{% onlyWhenNot mobi %}}
```bash
docker run -d --name apache-php -v $(pwd)/php-app:/var/www/html php:7-apache
```
{{% /onlyWhenNot %}}

{{% onlyWhen mobi %}}
```bash
docker run -d --name apache-php -v $(pwd)/php-app:/var/www/html REGISTRY/puzzle/k8s/kurs/php:7-apache
```
{{% /onlyWhen %}}

Windows (Git Bash):

{{% onlyWhenNot mobi %}}
```bash
MSYS_NO_PATHCONV=1 docker run -d --name apache-php -v $(pwd)/php-app/:/var/www/html php:7-apache
```
{{% /onlyWhenNot %}}

{{% onlyWhen mobi %}}
```bash
MSYS_NO_PATHCONV=1 docker run -d --name apache-php -v $(pwd)/php-app/:/var/www/html REGISTRY/puzzle/k8s/kurs/php:7-apache
```
{{% /onlyWhen %}}

{{% alert title="Note" color="primary" %}}
Do not forget to stop/remove the existing instance of the `apache-php` container before you start a new one.
{{% /alert %}}

{{% alert title="Note" color="primary" %}}
You need to set the absolute path on the -v option, e.g. `-v /home/<username>/php-app:/var/www/html` or `-v C:\Temp\php-app:/var/www/html`
{{% /alert %}}

You can now check whether the error is still present, or wait until the second question is answered.


## Port forwarding for your Docker container

Docker is able to forward any port you want/specify to your local machine. This is great but also has the possibility of causing port trouble.
Imagine you have a local httpd service running on port 80, and you are forwarding this same port to your Docker instance.

But let's not assume this right now! Or simply use a port other than 80.

As you might have guessed, it's a parameter called `-p <host-port>:<container-port>` that you can set:

Linux:

{{% onlyWhenNot mobi %}}
```bash
docker run -p 8080:80 -d --name apache-php -v $(pwd)/php-app:/var/www/html php:7-apache
```
{{% /onlyWhenNot %}}

{{% onlyWhen mobi %}}
```bash
docker run -p 8080:80 -d --name apache-php -v $(pwd)/php-app:/var/www/html REGISTRY/puzzle/k8s/kurs/php:7-apache
```
{{% /onlyWhen %}}

Windows (Git Bash):

{{% onlyWhenNot mobi %}}
```bash
MSYS_NO_PATHCONV=1 docker run -p 8080:80 -d --name apache-php -v $(pwd)/php-app/:/var/www/html php:7-apache
```
{{% /onlyWhenNot %}}

{{% onlyWhen mobi %}}
```bash
MSYS_NO_PATHCONV=1 docker run -p 8080:80 -d --name apache-php -v $(pwd)/php-app/:/var/www/html REGISTRY/puzzle/k8s/kurs/php:7-apache
```

{{% alert title="Note" color="primary" %}}
Do not forget to stop/remove the existing instance of the `apache-php` container before you start a new one.
{{% /alert %}}

If you take a look into `docker ps` you'll find an interesting change for the PORT column

```bash
docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
6b0721fa6103        php:7-apache        "docker-php-entryp..."   5 seconds ago       Up 4 seconds        0.0.0.0:8080->80/tcp   apache-php
50197361e87b        mariadb             "docker-entrypoint..."   2 hours ago         Up 2 hours          3306/tcp             mariadb-container-with-existing-external-volume
6f08ac657320        mariadb             "docker-entrypoint..."   5 hours ago         Up 2 hours          3306/tcp             mariadb-container
```

You see that every request coming to port 8080 on your local machine is forwarded to your Docker instance's port 80.
If you now type <http://LOCALHOST:8080/index.php> in your browser you should get the message: "Welcome to Docker...".

{{% alert title="Note" color="primary" %}}

* Instead of using a browser, you can also use `curl http://LOCALHOST:8080/index.php`.
* <http://LOCALHOST:8080/db.php> will produce an error. This is on purpose. Please be patient until the end of lab 10!
{{% /alert %}}

{{% alert title="Note for play-with-docker.com" color="primary" %}}
To access the frontend app, you have to use a special URL

* Copy the SSH connection command (`ssh ip172-18-0-30-bcvhrp0abk8g00cnf9jg@direct.labs.play-with-docker.com`)
* Remove *ssh* and replace the **@** with a **.**
* With that URL you will see the app page: `ip172-18-0-30-bcvhrp0abk8g00cnf9jg.direct.labs.play-with-docker.com`
{{% /alert %}}

> Question: Can I somehow link the containers together, so that they can talk to each other?

The answer lies in the [next lab](../09/).
