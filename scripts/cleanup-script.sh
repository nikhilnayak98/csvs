#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/cdp
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Docker cleanup script.

# Delete all running containers
docker kill $(docker ps -a)
docker rm $(docker ps -a)

# Delete all volumes
docker volume prune -f

# Delete webserver and dbserver images
docker rmi u2185920/csvs2022-db_i:latest u2185920/csvs2022-db_i:stripped
docker rmi u2185920/csvs2022-web_i:latest u2185920/csvs2022-web_i:stripped