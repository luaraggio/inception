# Inception - User Documentation

## Overview of Services

The Inception stack provides the following services:

- **MariaDB**: A relational database container that stores all WordPress data securely.
- **WordPress**: The CMS running your website, connected to the MariaDB database.
- **Nginx**: A reverse proxy that serves WordPress over HTTPS and handles client requests.

All services are connected via an **internal Docker network** for security and isolation.

---

## Starting and Stopping the Project

### Start the Stack

From the root of the project, run:

```bash
docker-compose up -d
```
This will:
Build the images if needed.
Launch all containers in detached mode.

### Stop the Stack

To stop and remove the containers:

```bash
docker-compose down
```
Persistent data in volumes and bind mounts will remain intact.

### Accessing the Website and Administration Panel

Open a web browser and navigate to:
```
https://<your_domain>
```
This is your WordPress website.

Access the WordPress admin panel at:

```https://<your_domain>/wp-admin```

Login using the credentials defined in the secrets:

WordPress admin password: stored in wp_admin_password secret.
WordPress user password: stored in wp_user_password secret.

## Locating and Managing Credentials

All sensitive passwords are stored in Docker secrets:

- MariaDB root password: db_root_password
- MariaDB user password: db_password
- WordPress admin password: wp_admin_password
- WordPress user password: wp_user_password

Secrets are mounted inside containers at:
```
/run/secrets/<secret_name>
```
To check a secret inside a container:

```bash
docker exec -it <container_name> cat /run/secrets/db_root_password
```
