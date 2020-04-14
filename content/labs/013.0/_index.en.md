---
title: "13.0 - Orchestration"
weight: 130
---

Instead of managing the containers with the `docker` command, you may use [Docker Compose](https://docs.docker.com/compose/) to handle them.

First **if on Ubuntu** install the `docker-compose` command:

```
sudo apt-get install docker-compose
```

**Note:** On Windows the Docker installer usually includes `docker-compose` already.

## Docker Compose file

Previously we run:

```
docker run --name mariadb-container-with-existing-external-volume -v$(pwd)/datastore-mysql:/var/lib/mysql -it -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb
```

and

```
docker run -itd --name php-app -p8080:80 --link mariadb-container-with-existing-external-volume php-app
```

We now create a file called `docker-compose.yml`:

```
version: '2'

services:

  php-app:
    image: php-app
    ports:
      - '8080:80'
    networks:
      - docker-techlab

  mariadb-container-with-existing-external-volume:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=my-secret-pw
    volumes:
      - 'volume-mariadb:/var/lib/mysql'
    networks:
      - docker-techlab

networks:
  docker-techlab:

volumes:
  volume-mariadb:
```

For each of the `docker run` commands, you add an entry under `services`, containing the appropriate options. The various options are described in the [Compose file reference](https://docs.docker.com/compose/compose-file/).

Having this file, you can run both containers with a simple command:

```
docker-compose up
```

Then again, check localhost/db.php in the browser.
