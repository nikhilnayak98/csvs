#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/csvs
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Docker repeated run script.

#########################
#       DBSERVER        #
#########################
# Vanilla version of dbserver container
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.179 \
        --hostname db.cyber22.test \
        -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" \
        -e MYSQL_DATABASE="csvs22db" \
        --name u2185920_csvs2022-db_c u2185920/csvs2022-db_i

#########################################################################
# Phase 1: Runtime Hardening Explanation                                #
# set network name                                                      #
# set ip                                                                #
# set hostname                                                          #
# set ip mapping with hostname                                          #
# set mysql root password                                               #
# set mysql database                                                    #
# set cpu core                                                          #
# set limited memory                                                    #
# set memory swap                                                       #
# set the container to be read only                                     #
# set writable temporary file systems required to run the container     #
# mount read only DBSERVERLOG_VOL volume                                #
# set read, write output directory for stracing                         #
# drops all capabilities                                                #
# add required capabilities                                             #
#########################################################################
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.179 \
        --hostname db.cyber22.test \
        -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" \
        -e MYSQL_DATABASE="csvs22db" \
        --cpuset-cpus=0 \
        --memory="300m" \
        --memory-swap="1g" \
        --read-only \
        --tmpfs /tmp \
        --tmpfs /var/run/mysqld \
        --tmpfs /var/lib/mysqld \
        --tmpfs /run/mysqld \
        --tmpfs /var \
        -v DBSERVERLOG_VOL:/var/log/dbserver/:ro \
        -v DBSERVERDATA_VOL:/var/lib/mysql/:rw \
        --cap-drop=ALL \
        --cap-add=SETGID --cap-add=SETUID --cap-add=CHOWN \
        --name u2185920_csvs2022-db_c u2185920/csvs2022-db_i

#########################################################################
# Phase 2: SELinux and Seccomp                                          #
#########################################################################
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.179 \
        --hostname db.cyber22.test \
        -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" \
        -e MYSQL_DATABASE="csvs22db" \
        --cpuset-cpus=0 \
        --memory="300m" \
        --memory-swap="1g" \
        --read-only \
        --tmpfs /tmp \
        --tmpfs /var/run/mysqld \
        --tmpfs /var/lib/mysqld \
        --tmpfs /run/mysqld \
        --tmpfs /var \
        -v DBSERVERLOG_VOL:/var/log/dbserver/:ro \
        -v DBSERVERDATA_VOL:/var/lib/mysql/:rw \
        -v $PWD/output_h:/output_c:rw \
        --cap-drop=ALL \
        --cap-add=SETGID --cap-add=SETUID --cap-add=CHOWN --cap-add=SYS_PTRACE \
        --security-opt label:type:docker_dbserver_t \
        --security-opt seccomp=docker_dbserver.json \
        --name u2185920_csvs2022-db_c u2185920/csvs2022-db_i

#########################################################################
# Phase 3: Final version stripped for attack surface reduction          #
#########################################################################
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.179 \
        --hostname db.cyber22.test \
        -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" \
        -e MYSQL_DATABASE="csvs22db" \
        --cpuset-cpus=0 \
        --memory="300m" \
        --memory-swap="1g" \
        --read-only \
        --tmpfs /tmp \
        --tmpfs /var/run/mysqld \
        --tmpfs /var/lib/mysqld \
        --tmpfs /run/mysqld \
        --tmpfs /var \
        -v DBSERVERLOG_VOL:/var/log/dbserver/:ro \
        -v DBSERVERDATA_VOL:/var/lib/mysql/:rw \
        --cap-drop=ALL \
        --cap-add=SETGID --cap-add=SETUID --cap-add=CHOWN \
        --security-opt label:type:docker_dbserver_t \
        --security-opt seccomp=docker_dbserver.json \
        --name u2185920_csvs2022-db_c u2185920/csvs2022-db_i:stripped
#############################################################################################################


#########################
#       WEBSERVER       #
#########################
# Vanilla version of webserver container
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.180 \
        --hostname www.cyber22.test \
        --add-host db.cyber22.test:198.51.100.179 \
        -p 80:80 \
        --name u2185920_csvs2022-web_c u2185920/csvs2022-web_i

#########################################################################
# Phase 1: Runtime Hardening Explanation                                #
# set network name                                                      #
# set ip                                                                #
# set hostname                                                          #
# set ip mapping with hostname                                          #
# set port mapping with host machine                                    #
# set cpu core                                                          #
# set limited memory                                                    #
# set memory swap                                                       #
# set the container to be read only                                     #
# set writable temporary file systems required to run the container     #
# mount read only WEBSERVERLOG_VOL volume                               #
# set read, write output directory for stracing                         #
# drops all capabilities                                                #
# add the required capabilities                                         #
# set name of the container                                             #
#########################################################################
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.180 \
        --hostname www.cyber22.test \
        --add-host db.cyber22.test:198.51.100.179 \
        -p 80:80 \
        --cpuset-cpus=0 \
        --memory="100m" \
        --memory-swap="300m" \
        --read-only \
        --tmpfs /var/log/nginx \
        --tmpfs /var/lib/nginx/tmp \
        --tmpfs /var/log/php-fpm \
        --tmpfs /var/run/php-fpm \
        --tmpfs /run \
        -v WEBSERVERLOG_VOL:/var/log/webserver/:ro \
        --cap-drop=ALL \
        --cap-add=CHOWN --cap-add=SETGID --cap-add=SETUID --cap-add=NET_BIND_SERVICE \
        --name u2185920_csvs2022-web_c u2185920/csvs2022-web_i

#########################################################################
# Phase 2: SELinux and Seccomp                                          #
#########################################################################
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.180 \
        --hostname www.cyber22.test \
        --add-host db.cyber22.test:198.51.100.179 \
        -p 80:80 \
        --cpuset-cpus=0 \
        --memory="100m" \
        --memory-swap="300m" \
        --read-only \
        --tmpfs /var/log/nginx \
        --tmpfs /var/lib/nginx/tmp \
        --tmpfs /var/log/php-fpm \
        --tmpfs /var/run/php-fpm \
        --tmpfs /run \
        -v WEBSERVERLOG_VOL:/var/log/webserver/:ro \
        -v $PWD/output_h:/output_c:rw \
        --cap-drop=ALL \
        --cap-add=CHOWN --cap-add=SETGID --cap-add=SETUID --cap-add=NET_BIND_SERVICE --cap-add=SYS_PTRACE \
        --security-opt label:type:docker_webserver_t \
        --security-opt seccomp=docker_webserver.json \
        --name u2185920_csvs2022-web_c u2185920/csvs2022-web_i

#########################################################################
# Phase 3: Final version stripped for attack surface reduction          #
#########################################################################
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.180 \
        --hostname www.cyber22.test \
        --add-host db.cyber22.test:198.51.100.179 \
        -p 80:80 \
        --cpuset-cpus=0 \
        --memory="100m" \
        --memory-swap="300m" \
        --read-only \
        --tmpfs /var/log/nginx \
        --tmpfs /var/lib/nginx/tmp \
        --tmpfs /var/log/php-fpm \
        --tmpfs /var/run/php-fpm \
        --tmpfs /run \
        --cap-drop=ALL \
        --cap-add=CHOWN --cap-add=SETGID --cap-add=SETUID --cap-add=NET_BIND_SERVICE \
        --security-opt label:type:docker_webserver_t \
        --security-opt seccomp=docker_webserver.json \
        --name u2185920_csvs2022-web_c u2185920/csvs2022-web_i:stripped