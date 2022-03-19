#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/csvs
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Sets up everything for smooth run

# Clean everything
./cleanup-script.sh

# Create docker network
docker network create --subnet=198.51.100.0/24 u2185920/csvs2022_n

# Build images
./build-script.sh

# Strip the images
echo -ne '\n' | ../builds/dbserver/strip-cmd
../builds/webserver/strip-cmd

# Delete non required files
rm slim.report.json

# Start dbserver
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.179 \
        --hostname db.cyber22.test \
        -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" \
        -e MYSQL_DATABASE="csvs22db" \
        --cpuset-cpus=0 \
        --memory="300m" \
        --memory-swap="1g" \
        --pids-limit 50 \
        --restart=on-failure:5 \
        --read-only \
        --tmpfs /tmp \
        --tmpfs /var/run/mysqld \
        --tmpfs /var/lib/mysqld \
        --tmpfs /run/mysqld \
        -v DBSERVERDATA_VOL:/var/lib/mysql/:rw \
        --cap-drop=ALL \
        --security-opt=no-new-privileges \
        --name u2185920_csvs2022-db_c u2185920/csvs2022-db_i

sleep 10

# Import database schema
docker exec -i u2185920_csvs2022-db_c mysql -uroot -pCorrectHorseBatteryStaple < ../builds/dbserver/sqlconfig/csvs22db.sql

# Remove dbserver
docker rm -f u2185920_csvs2022-db_c