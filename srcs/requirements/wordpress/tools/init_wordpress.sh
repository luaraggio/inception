#!/bin/bash
set -e

# ------------------------------------------------------------
# Move to the WordPress installation directory
# ------------------------------------------------------------
cd /var/www/html

# ------------------------------------------------------------
# Read secrets from Docker secret files
# ------------------------------------------------------------
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# ------------------------------------------------------------
# Non-sensitive variables from .env
# ------------------------------------------------------------
DB_NAME="$MYSQL_DATABASE"
DB_USER="$MYSQL_USER"
DB_HOST="$MYSQL_HOST"
DOMAIN="$DOMAIN_NAME"
WP_ADMIN_USER="$WP_ADMIN_USER"
WP_ADMIN_EMAIL="$WP_ADMIN_EMAIL"
WP_USER="$WP_USER"
WP_USER_EMAIL="$WP_USER_EMAIL"

# ------------------------------------------------------------
# Wait until MariaDB server is reachable
# ------------------------------------------------------------
echo "[INFO] Waiting for MariaDB..."
until mysqladmin ping -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
    sleep 2
done
echo "[INFO] MariaDB is ready."

# ------------------------------------------------------------
# Install WP-CLI if not installed
# ------------------------------------------------------------
if ! command -v wp >/dev/null 2>&1; then
    echo "[INFO] Installing WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# ------------------------------------------------------------
# Download WordPress core if not present
# ------------------------------------------------------------
if [ ! -f wp-config.php ]; then
    echo "[INIT] Downloading WordPress core..."
    wp core download --allow-root

    # --------------------------------------------------------
    # Create wp-config.php with correct database credentials
    # --------------------------------------------------------
    echo "[INIT] Creating wp-config.php..."
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --allow-root

    # --------------------------------------------------------
    # Install WordPress and create admin user
    # --------------------------------------------------------
    echo "[INIT] Installing WordPress..."
    wp core install \
        --url="$DOMAIN" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
fi

# ------------------------------------------------------------
# Create admin user if missing
# ------------------------------------------------------------
if ! wp user get "$WP_ADMIN_USER" --allow-root >/dev/null 2>&1; then
    echo "[INIT] Creating admin user..."
    wp user create "$WP_ADMIN_USER" "$WP_ADMIN_EMAIL" \
        --role=administrator \
        --user_pass="$WP_ADMIN_PASSWORD" \
        --allow-root
else
    # Always update admin password
    wp user update "$WP_ADMIN_USER" --user_pass="$WP_ADMIN_PASSWORD" --allow-root
fi

# ------------------------------------------------------------
# Create additional WordPress user if missing
# ------------------------------------------------------------
if ! wp user get "$WP_USER" --allow-root >/dev/null 2>&1; then
    echo "[INIT] Creating additional WordPress user..."
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root
else
    # Always update user password
    wp user update "$WP_USER" --user_pass="$WP_USER_PASSWORD" --allow-root
fi

# ------------------------------------------------------------
# Start PHP-FPM in foreground mode
# ------------------------------------------------------------
echo "[START] Launching PHP-FPM..."
exec php-fpm8.2 -F
