# USER_DOC

## Overview

This infrastructure provides a secure WordPress environment using Docker.  
The stack includes:

- NGINX (HTTPS reverse proxy)
- WordPress + PHP-FPM
- MariaDB database
- Redis cache (bonus)
- Adminer (database web UI)
- FTP server (file management)
- Static website
- Backup service

All services communicate through a dedicated Docker network.

---

## Start the Project

From the project root:

```bash
make