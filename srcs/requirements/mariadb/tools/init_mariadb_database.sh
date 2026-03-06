#!/bin/bash
set -e

# ------------------------------------------------------------
# Read secrets from files (Docker secrets simulation)
# ------------------------------------------------------------
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password.txt)
DB_USER_PASSWORD=$(cat /run/secrets/db_password.txt)

# ------------------------------------------------------------
# Non-sensitive variables from .env
# ------------------------------------------------------------
DB_NAME="$MYSQL_DATABASE"
DB_USER="$MYSQL_USER"

# ------------------------------------------------------------
# Check if the database already exists
# ------------------------------------------------------------
if [ -d "/var/lib/mysql/$DB_NAME" ]; then
    echo "[INFO] Database '$DB_NAME' already initialized, starting MariaDB..."
    exec mysqld --user=mysql
fi

# ------------------------------------------------------------
# Start temporary MariaDB server for bootstrap
# ------------------------------------------------------------
echo "[INIT] Starting temporary MariaDB server..."
mysqld --skip-networking --socket=/tmp/mysql.sock --user=mysql &
MYSQLD_TEMP_PID=$!

# Wait until server is ready
until mysqladmin ping --socket=/tmp/mysql.sock --silent; do
    sleep 1
done

# ------------------------------------------------------------
# Create database if it doesn't exist
# ------------------------------------------------------------
echo "[INIT] Creating database and user (idempotent)..."
mysql --socket=/tmp/mysql.sock -uroot <<-EOSQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOSQL

# ------------------------------------------------------------
# Stop temporary server
# ------------------------------------------------------------
echo "[INIT] Shutting down temporary MariaDB server..."
mysqladmin --socket=/tmp/mysql.sock -uroot -p"${DB_ROOT_PASSWORD}" shutdown
wait $MYSQLD_TEMP_PID

# ------------------------------------------------------------
# Start MariaDB as PID 1 for Docker
# ------------------------------------------------------------
echo "[START] Running MariaDB as PID 1..."
exec mysqld --user=mysql
