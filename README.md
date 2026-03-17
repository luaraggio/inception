*This project has been created as part of the 42 curriculum by lraggio.*

# Inception

## Description

Inception is a project that simulates a small-scale web hosting environment using Docker.
The stack includes **MariaDB**, **WordPress**, and **Nginx**, configured to run together in isolated containers. The main goal of the project is to learn and demonstrate **containerization, networking, volume management, and secure secrets handling** in a Docker-based environment.

The project includes:

- A **MariaDB** database container, initialized securely with secrets.
- A **WordPress** container for CMS functionality, connected to the database.
- An **Nginx** reverse proxy, serving WordPress over HTTPS.
- Persistent data storage using Docker volumes and bind mounts.
- Internal networking to isolate services and enhance security.

### Docker Design Choices

- **Virtual Machines vs Docker:** Docker provides lightweight, fast startup containers, unlike VMs which require full OS virtualization. This allows multiple services to run efficiently on the same host.
- **Secrets vs Environment Variables:** Secrets are stored securely as files mounted inside containers, preventing exposure in process lists or version control. Environment variables are easier to set but less secure.
- **Docker Network vs Host Network:** Docker networks isolate service traffic and simplify container-to-container communication. Host networking exposes containers directly, which can reduce security and portability.
- **Docker Volumes vs Bind Mounts:** Volumes are managed by Docker and provide data persistence and portability. Bind mounts directly map host directories, giving full access to host files but requiring proper permission management.

---

## Instructions

### Prerequisites

- Docker
- Docker Compose
- Git
- Make (optional, if using the provided Makefile)

### Build and Launch

1. Clone the repository:

```bash
git clone <repo_url>
cd inception
```

2. Create the required secret files inside a secrets/ folder:

```
mkdir secrets
echo "root_password_here" > secrets/db_root_password.txt
echo "user_password_here" > secrets/db_password.txt
echo "admin_password_here" > secrets/wp_admin_password.txt
echo "user_password_here" > secrets/wp_user_password.txt
```

3. Create persistent data directories:

```
mkdir -p /home/lraggio/data/mariadb
mkdir -p /home/lraggio/data/wordpress
```

4. Build and start the stack
```
docker-compose up --build -d
```
or
```
make
```

5. Access the services:

- WordPress: https://lraggio.42.fr
- Nginx: Reverse proxy handles HTTPS
- MariaDB: internal container access for administration

6. Stop and cleaning:

```
docker-compose down
```
Persistent data remains in /home/lraggio/data/.

## Resources

### Docker Documentation: https://docs.docker.com
### Docker Compose Documentation: https://docs.docker.com/compose/
### WordPress Docker Guide: https://hub.docker.com/_/wordpress
### MariaDB Docker Guide: https://hub.docker.com/_/mariadb

## AI Usage:
### AI assistance was used to:

- Refactor Docker Compose files and secrets handling scripts.
- Write and organize the README documentation.
- Suggest best practices for Docker networks, volumes, and secure initialization scripts.

## Additional Notes

- The stack uses internal networks to isolate traffic between containers.
- All passwords and sensitive data are handled using Docker secrets mounted inside containers.
- Bind mounts are used for persistence, allowing host directories to store database and WordPress files.
