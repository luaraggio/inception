FROM debian:bookworm

#Instala mariadb
RUN apt update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

#Cria diretórios necessários e dá permissão
# Faz o usuário mysql ser dono de todos os arquivos e diretórios dentro de /var/lib/mysql, a flag -R
# é para que a operação seja recursiva (funcione para o diretório que eu passei e todos dentro dele)
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql var/lib/mysql

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init_mariadb_database.sh .

RUN chmod +x /init_mariadb_database.sh

EXPOSE 3306

#Entrypoint do container
CMD ["/init_mariadb_database.sh"]
