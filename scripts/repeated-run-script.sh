#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/cdp
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Docker repeated run script.

# dbserver stripping
../../scripts/strip-image  \
    -i u2185920/csvs2022-db_i \
    -p mariadb-server \
    -f /tmp \
    -f /var/lib/mysqld \
    -f /run/mysqld \
    -f /var \
    -d Dockerfile \
    -t u2185920/csvs2022-db_i:stripped

# webserver stripping
../../scripts//strip-image  \
    -i u2185920/csvs2022-web_i \
    -p nginx \
    -f /etc/passwd \
    -f /etc/group \
    -f '/lib/*/libnss*' \
    -f /bin/ls \
    -f /bin/cat \
    -f /bin/sh \
    -f /bin/mkdir \
    -f /bin/ps \
    -f /var/run \
    -f /var/log/nginx \
    -f /usr/sbin/php-fpm \
    -f /etc/nginx/nginx.conf \
    -f /etc/php-fpm.conf \
    -f /etc/php-fpm.d/*.conf \
    -f /usr/share/nginx/html \
    -f /docker-entrypoint.sh \
    -d Dockerfile \
    -t u2185920/csvs2022-web_i:stripped