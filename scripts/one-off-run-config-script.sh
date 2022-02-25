#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/cdp
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Docker one off run script.

# Docker network
docker network create --subnet=198.51.100.0/24 u2185920/csvs2022_n

# Run dbserver container
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.179 \
        --hostname db.cyber22.test \
        -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" \
        -e MYSQL_DATABASE="csvs22db" \
        --name u2185920_csvs2022-db_c u2185920/csvs2022-db_i

# Prep db
docker exec -i u2185920_csvs2022-db_c mysql -uroot -pCorrectHorseBatteryStaple < sqlconfig/csvs22db.sql

# Run webserber container
docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.180 \
        --hostname www.cyber22.test \
        --add-host db.cyber22.test:198.51.100.179 \
        -p 80:80 \
        --name u2185920_csvs2022-web_c u2185920/csvs2022-web_i
