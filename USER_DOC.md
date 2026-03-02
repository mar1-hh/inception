# USER_DOC

## Services Provided

This infrastructure deploys a complete WordPress environment using Docker.

The stack provides:

- **NGINX**: HTTPS reverse proxy (port 443)
- **WordPress + PHP-FPM**: dynamic website
- **MariaDB**: database for WordPress
- **Redis** (bonus): caching service
- **Adminer** (bonus): web interface for database management
- **FTP server** (bonus): file upload access to WordPress files
- **Static site** (bonus): simple static web server
- **Backup service** (bonus): automatic database backups

All services run in isolated containers connected through the `inception` Docker network.

---

## Start the Project

From the project root directory:

```bash
make
````

or:

```bash
make up
```

This command builds the images and starts all containers in detached mode.

---

## Stop the Project

To stop and remove the containers:

```bash
make down
```

---

## Restart the Project

To rebuild and restart everything:

```bash
make re
```

---

## Access the Website

Open your browser and go to:

```
https://msaadaou.42.fr
```

---

## Access the WordPress Administration Panel

Open:

```
https://msaadaou.42.fr/wp-admin
```

Log in using the administrator credentials defined in the `.env` file.

---

## Access Adminer (Database Interface)

Open in browser:

```
http://localhost:8081
```

Use the following connection settings:

* System: MySQL
* Server: `mariadb`
* Username: value from `.env`
* Password: value from `.env`
* Database: `wordpress`

---

## FTP Access (Bonus)

You can upload files to WordPress using FTP.

Connection settings:
* User: value of `FTP_USER` in `.env`
* Password: value of `FTP_PASS` in `.env`

Uploaded files appear inside the WordPress directory.

---

## Location of Credentials

All sensitive credentials are stored in:

```
srcs/.env
```

This file contains:

* database credentials
* WordPress admin credentials
* FTP credentials

Passwords are **not hardcoded** in Dockerfiles.

---

## Verify That Services Are Running

Check container status:

```bash
docker compose ps
```

or:

```bash
make ps
```

All services should show **Up**.

---

## Check Logs

To inspect a specific service:

```bash
docker compose logs <service_name>
```

Examples:

```bash
docker compose logs nginx
docker compose logs wordpress
docker compose logs mariadb
```

---

## Backup Files (Bonus)

Database backups are automatically created and stored in:

```
/home/marouane/data/backups
```

---

