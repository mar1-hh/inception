*This project has been created as part of the 42 curriculum by msaadaou*

## Project Description

Inception is a DevOps project from the 42 curriculum focused on containerization using Docker and Docker Compose.

The project consists of building a secure and modular web infrastructure where each service runs inside its own container. The architecture includes:

- NGINX configured with TLS (HTTPS)
- WordPress running with PHP-FPM
- MariaDB database
- Docker named volumes for persistent storage
- A dedicated Docker network for inter-container communication

### Why Docker Was Used

Docker was chosen to:

- Isolate each service in its own environment  
- Simplify deployment and dependency management  
- Reduce resource consumption compared to full virtual machines  
- Provide scalable and modular infrastructure  

Docker Compose was used to setup and manage the multi-container networking and volumes automatically.

---

## Design Choices

The infrastructure was designed with the following principles:

- One service per container (NGINX, WordPress, MariaDB)
- No use of host network for security and isolation
- Use of Docker named volumes for persistent data
- Automatic container startup using a Makefile
- TLS encryption enabled via NGINX
- Internal Docker network for secure service communication

These choices follow Docker best practices and the requirements of the subject.

---

## Comparisons

### Virtual Machines vs Docker

**Virtual Machines**

- Emulate full operating systems  
- Heavy resource usage (RAM, CPU, disk)  
- Slow startup time  
- Strong isolation  
- Larger disk footprint  

**Docker Containers**

- Share the host kernel  
- Lightweight and fast to start  
- Lower resource consumption  
- Easier to deploy and reproduce  
- Better suited for microservice architectures  

✅ **Why Docker was chosen:**  
Docker provides faster deployment and lower overhead, which fits the project’s microservices architecture.

---

### Secrets vs Environment Variables

**Environment Variables**

- Easy to use and configure  
- Stored in plain text  
- Visible in container metadata  
- Less secure for sensitive data  

**Docker Secrets**

- Designed for sensitive information  
- Stored securely by Docker  
- Not exposed in environment output  
- Better for production security  

✅ **Choice in this project:**  
Environment variables were used because they are sufficient for a controlled development environment, but Docker Secrets would be preferred in production.

---

### Docker Network vs Host Network

**Host Network**

- Container shares host network stack  
- No network isolation  
- Higher security risk  
- Possible port conflicts  

**Docker Bridge Network (used here)**

- Isolated internal network  
- Automatic DNS between containers  
- Better security  
- Cleaner service communication  

✅ **Why bridge network was chosen:**  
It provides isolation and secure inter-container communication, which aligns with best practices and the project requirements.

---

### Docker Volumes vs Bind Mounts

**Bind Mounts**

- Direct mapping to host filesystem  
- More flexible  
- Host-dependent paths  
- Can create permission issues  
- Less portable  

**Docker Named Volumes (used here)**

- Managed by Docker  
- More portable  
- Better abstraction  
- Easier backup and migration  
- Recommended by the subject  

✅ **Why named volumes were chosen:**  
This project uses Docker named volumes whose data is stored under /home/msaadaou/data on the host.

---



## Instructions

### Requirements

Make sure you have:

- Docker
- Docker Compose
- GNU Make

Check:

```bash
docker --version
docker compose version
make --version
````

---

### Hostname Setup

Add your domain to your hosts file so it resolves locally:

```bash
sudo nano /etc/hosts
```

Add (or ensure it exists):

```bash
127.0.0.1 msaadaou.42.fr
```

> Replace `msaadaou.42.fr` with the domain you configured in your NGINX/SSL setup.

---

### Persistent Data Directories

This project uses persistent directories on the host machine (created automatically by the Makefile):

* `/home/msaadaou/data/mysql`
* `/home/msaadaou/data/wordpress`
* `/home/msaadaou/data/backups`

You can create them manually (optional), but `make` already does it:

```bash
mkdir -p /home/msaadaou/data/mysql
mkdir -p /home/msaadaou/data/wordpress
mkdir -p /home/msaadaou/data/backups
```

---

### Build and Run

To build and start all services:

```bash
make
```

This will:

* Create the data directories under `/home/msaadaou/data`
* Build all images
* Start the containers in detached mode (`-d`)

---

### Stop the Infrastructure

To stop and remove the containers (without deleting images and volumes):

```bash
make down
```

---

### Restart From Scratch

To restart everything (stop then start again):

```bash
make re
```

---

### Cleaning Targets

**Clean** (same as `down` in this Makefile):

```bash
make clean
```

**Full clean** (removes containers, images, volumes AND deletes host data directories):

```bash
make fclean
```

⚠️ `make fclean` will:

* Remove all built images related to the compose file (`--rmi all`)
* Remove volumes (`-v`)
* Delete the following directories:

```bash
sudo rm -rf /home/msaadaou/data/mysql
sudo rm -rf /home/msaadaou/data/wordpress
sudo rm -rf /home/msaadaou/data/backups
```

Use it only if you want a completely fresh setup.

---

### Useful Commands

Check running containers:

```bash
docker ps
```

View logs:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

## Resources

### References

The following resources were used to understand and implement the project:

- Ahmed Sami — Docker explanation: https://www.youtube.com/watch?v=PrusdhS2lmo&t=11616s
- Official Docker documentation: https://docs.docker.com/

These materials were mainly used to learn Docker fundamentals, Docker Compose usage, networking, and volume management.

---

### AI Usage

AI tools (ChatGPT) were used as a learning assistant during the project.

**How AI was used:**
- To understand deeply how certain Docker and DevOps concepts work
- To explore best practices and debug issues during development
- To learn new concepts encountered for the first time

Here is a clean **Bonus section** you can paste directly into your `README.md`.

It is written in the style evaluators like and matches the Inception bonus rules.

---

## ⭐ Bonus Part

The following bonus features have been implemented to extend the mandatory infrastructure and improve the overall stack.

---

### 🔹 Redis Cache (WordPress Performance)

A Redis container is added to improve WordPress performance by caching database queries and PHP objects.

**Benefits:**

* Faster page loading
* Reduced database load
* Better scalability
* Persistent cache support

**Integration:**

* WordPress is configured to use Redis as object cache
* Redis runs in its own container
* Connected through the Docker network
* No public port exposed

**How to verify:**

* Log into WordPress admin
* Go to **Tools → Site Health → Info → Object Cache**
* Or check Redis container logs:

```bash
docker compose logs redis
```

---

### 🔹 FTP Server (File Management)

An FTP service is provided to allow secure remote access to the WordPress files.

**Features:**

* Points to WordPress volume
* Dedicated container
* User authentication enabled
* Passive mode configured
* Runs on its own port (if exposed)

**Use cases:**

* Upload themes/plugins
* Manage media files
* Remote file editing

**Connection example:**

```
Host: <login>.42.fr
User: <FTP_USER>
Password: <FTP_PASSWORD>
Port: 21
```

---

### 🔹 Adminer (Database Management)

Adminer is included as a lightweight web database management tool.

**Advantages over phpMyAdmin:**

* Single PHP file
* Lightweight
* Fast
* Easy to deploy

**Access:**

```
https://<login>.42.fr/adminer
```

**Usage:**

* Inspect WordPress database
* Run SQL queries
* Debug database issues

---

### 🔹 Static Website

A simple static website container has been added.

**Purpose:**

* Demonstrate multi-service architecture
* Serve a lightweight landing page
* Practice additional containerization

**Technology used:**

* HTML/CSS (no PHP as required)

---

### 🔹 Automatic Database Backup (Optional Advanced Bonus)

A backup service periodically runs `mysqldump` to create database backups.

**Features:**

* Runs in dedicated container
* Saves backups to persistent volume
* Timestamped backup files
* Non-interactive execution

**Verify backups:**

```bash
docker compose logs backup
```

or check backup directory.

---

## 🧠 Bonus Architecture Summary

With bonuses enabled, the infrastructure includes:

* NGINX
* WordPress + PHP-FPM
* MariaDB
* Redis
* FTP server
* Adminer
* Static website
* Backup service

All services:

* run in isolated containers
* communicate via Docker network
* persist data using named volumes
* follow Inception constraints

