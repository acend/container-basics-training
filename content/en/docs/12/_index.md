---
title: "12. Orchestration"
weight: 12
---

Instead of managing the containers with the `docker` command, you may use [Docker Compose](https://docs.docker.com/compose/) to handle them.

{{% alert title="Note" color="primary" %}}
Ubuntu users need to install the `docker-compose` command:

```bash
sudo apt-get install docker-compose
```

On Windows, the Docker installer usually includes `docker-compose` already.
{{% /alert %}}


## Docker Compose file

Previously we ran:

```bash
docker run --name mariadb-container-with-existing-external-volume -v$(pwd)/datastore-mysql:/var/lib/mysql -it -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb
```

and:

```bash
docker run -itd --name php-app -p8080:80 --link mariadb-container-with-existing-external-volume php-app
```

We now create a file called `docker-compose.yml`:

```yaml
version: '3'

services:

  php-app:
    image: php-app
    ports:
      - '8080:80'
    networks:
      - container-basics-training

  mariadb-container-with-existing-external-volume:
    image: mariadb
    environment:
      - MARIADB_ROOT_PASSWORD=my-secret-pw
    volumes:
      - 'volume-mariadb:/var/lib/mysql'
    networks:
      - container-basics-training

networks:
  container-basics-training:

volumes:
  volume-mariadb:
```

For each of the `docker run` commands, you add an entry under `services`, containing the appropriate options. The various options are described in the [Compose file reference](https://docs.docker.com/compose/compose-file/).

Having this file, you can run both containers with a simple command:

```bash
docker-compose up
```

Then again, check <http://LOCALHOST:8080/db.php> in a browser.
