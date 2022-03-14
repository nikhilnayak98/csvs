# Database Dockerfile

FROM mariadb:10

COPY configfiles/mysqld.cnf  /mysql/mysql.conf.d/mysqld.cnf

EXPOSE 3306

RUN chown -R mysql:mysql /var/lib/mysql

USER mysql

CMD ["mysqld"]