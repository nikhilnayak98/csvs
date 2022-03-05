#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/csvs
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Docker one off run script.

# Docker network
docker network create --subnet=198.51.100.0/24 u2185920/csvs2022_n


#########################
# SELinux               #
#########################
# Compile textual file into an executable policy file
sudo make -f /usr/share/selinux/devel/Makefile docker_dbserver.pp
sudo make -f /usr/share/selinux/devel/Makefile docker_webserver.pp


# Insert the policy file into the active kernel policies to be used
sudo semodule -i docker_dbserver.pp
sudo semodule -i docker_webserver.pp

# Confirm it is present and check the version number
sudo semodule -l | grep docker

# Start application with label
# Use the service, then check for report policy contraventions
sudo cat /var/log/audit/audit.log

# Convert these contraventions to text which could be editted into .te file
sudo ausearch -m avc --start recent | audit2allow -r

# Ensure SELinux is enforcing
sudo setenforce 1


#########################
# Stripping             #
#########################
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