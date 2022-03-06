# Database Dockerfile

FROM mariadb:10

COPY configfiles/mysqld.cnf  /mysql/mysql.conf.d/mysqld.cnf

# Initializing a fresh instance, (Citation: Docker Hub, https://hub.docker.com/_/mysql)
COPY sqlconfig/csvs22db.sql /docker-entrypoint-initdb.d

EXPOSE 3306

VOLUME /var/log/dbserver/