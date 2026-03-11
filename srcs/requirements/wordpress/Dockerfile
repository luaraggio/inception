FROM debian:bookworm

RUN apt update && \
    apt-get install -y php-fpm \
    php-mysqli \
    curl \
    ca-certificates \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/.

COPY tools/init_wordpress.sh /init_wordpress.sh

RUN chmod +x /init_wordpress.sh

EXPOSE 9000

CMD ["/init_wordpress.sh"]
