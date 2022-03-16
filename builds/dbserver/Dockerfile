# Database Dockerfile

FROM mariadb:10

LABEL org.opencontainers.image.authors="Nikhil Ranjan Nayak <Nikhil-Ranjan.Nayak@warwick.ac.uk>"

LABEL description="DBServer Image"

COPY configfiles/mysqld.cnf  /mysql/mysql.conf.d/mysqld.cnf

EXPOSE 3306

RUN chown -R mysql:mysql /var/lib/mysql

USER mysql

CMD ["mysqld"]
