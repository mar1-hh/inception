
# DEV_DOC

## Environment Setup

### Prerequisites

Before building the project, ensure the following are installed:

- Docker
- Docker Compose
- Make
- Linux environment (VM recommended)

Verify installation:

```bash
docker --version
docker compose version
make --version
````

---

### Domain Configuration

Edit the hosts file:

```bash
sudo nano /etc/hosts
```

Add:

```
127.0.0.1 <login>.42.fr
```

Example:

```
127.0.0.1 msaadaou.42.fr
```

---

### Required Directories

Persistent data is stored under:

```
/home/<login>/data/
```

Create the directories:

```bash
mkdir -p /home/<login>/data/mysql
mkdir -p /home/<login>/data/wordpress
mkdir -p /home/<login>/data/backups
```

---

### Environment Variables

All secrets and configuration values are stored in:

```
srcs/.env
```

This file contains:

* database credentials
* WordPress admin credentials
* FTP credentials
* Redis configuration

⚠️ Passwords are not hardcoded in Dockerfiles.

---

## Build and Launch the Project

From the project root:

```bash
make
```

or:

```bash
make up
```

This will:

* build Docker images
* create volumes
* create the network
* start all containers

---

## Stop the Project

```bash
make down
```

---

## Rebuild the Project

```bash
make re
```

---

## Container Management

### List running containers

```bash
docker compose ps
```

---

### View logs

```bash
docker compose logs <service>
```

Examples:

```bash
docker compose logs nginx
docker compose logs wordpress
docker compose logs mariadb
```

---

### Access a container shell

```bash
docker exec -it <container_name> sh
```

Example:

```bash
docker exec -it mariadb sh
```

---

## Volume Management

### List volumes

```bash
docker volume ls
```

---

### Inspect a volume

```bash
docker volume inspect <volume_name>
```

Example:

```bash
docker volume inspect mariadb_data
```

---

## Data Persistence

The project uses Docker named volumes to persist data.

Persistent storage includes:

* MariaDB database → mounted at `/var/lib/mysql`
* WordPress files → mounted at `/var/www/html`
* Backups → mounted at `/backups`

---

## Host Storage Location

All persistent data is stored on the host under:

```
/home/marouane/data/
```

This ensures data survives container removal.

---

## Network Architecture

All services communicate through the `inception` bridge network.

Internal service ports:

* NGINX → 443
* WordPress PHP-FPM → 9000
* MariaDB → 3306
* Redis → 6379
* FTP → 21 and passive ports

Only NGINX is exposed publicly (mandatory requirement).

---

## Cleaning the Environment

### Remove containers

```bash
make down
```

---

### Full cleanup (including volumes and data)

```bash
make fclean
```

⚠️ This removes all persistent data.
