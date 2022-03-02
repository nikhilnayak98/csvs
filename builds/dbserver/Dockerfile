# Database Dockerfile

FROM mariadb:10

COPY configfiles/mysqld.cnf  /mysql/mysql.conf.d/mysqld.cnf
COPY sqlconfig/csvs22db.sql /docker-entrypoint-initdb.d

EXPOSE 3306

VOLUME /var/log/dbserver/