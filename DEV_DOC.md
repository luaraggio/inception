# Inception - Developer documentation

### **DEV_DOC.md**

```markdown
# Inception - Developer Documentation

## Environment Setup

### Prerequisites

- **Docker** (latest stable version)
- **Docker Compose**
- **Git**
- **Make** (optional, if using the provided Makefile)

### Configuration Files

- `.env` – contains non-sensitive environment variables.
- `secrets/` – contains sensitive credentials as plain text files:

```text
secrets/db_root_password.txt
secrets/db_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

- `docker-compose.yml` – defines all services, networks, volumes, and secrets.
- `Makefile` – optional helper to build and run services with simple commands.

# How to test?

### Checking Service Status

Check running containers:

```bash
docker ps
```

Check logs for troubleshooting:

```bash
docker-compose logs -f
```
or

```makefile
make logs
```
Ensure the website is accessible via HTTPS and that WordPress can connect to the database.

# Checking if the services are running correctly

## Mariadb

MariaDB is the relational database service used by WordPress. The following steps help you verify its setup, access the database, and test persistence.

### Starting and Viewing Logs

- View logs

```bash
make mariadb_logs
```

- Enter the MariaDB container:

```bash
make mariadb_bash
```

## Connecting to MySQL

### As root:

```bash
mysql -u root -p
```

- check existing databases:

```bash
SHOW DATABASES;
```

there must be something like:
```
wordpress
mysql
information_schema
performance_schema
```

```bash
exit
```

### As a user:

```bash
mysql -u >nome_do_usuário< -p
```

- select a database:

```bash
USE wordpress;
```

- list tables inside the database:

```bash
SHOW TABLES;
```

```bash
exit
```

### Checking Network

- Verify MariaDB is listening on port 3306 inside the container:
```bash
ss -lntp | grep 3306
```

- Test network connectivity from host::
```bash
nc localhost 3306
```

### Testing Data Persistence

- Stop and remove containers (data will persist)::
```bash
make fclean
```

- Start the MariaDB container again:
```bash
make mariadb_service
```
## Wordpress

WordPress is a PHP-based CMS that relies on MariaDB for data storage. It requires three main components:

Nginx – Serves static files and handles HTTPS requests.
PHP-FPM – Processes PHP code, since Nginx cannot execute PHP directly.
MariaDB – Stores all site content, users, and settings.

### Accessing the WordPress Container

- Enter the container:

```bash
make wordpress_bash
```

or

```bash
docker exec -it wordpress bash
```

- List WordPress users (requires root):

```bash
wp user list --allow-root
````

- Restart the WordPress container:

```bash
docker-compose restart wordpress
```

- Check logs for troubleshooting:
```bash
make wordpress_logs
```
or
```bash
docker logs wordpress
```

### Testing Connectivity

- Test Nginx + WordPress availability:

```bash
curl https://localhost
```

- Test MariaDB connectivity from WordPress container:

```bash
nc mariadb 3306
```
