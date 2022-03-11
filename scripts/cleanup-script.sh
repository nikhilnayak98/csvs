#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/csvs
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

# Delete SELinux stuff
echo "csc" | sudo -S semodule -r docker_webserver
sudo semodule -r docker_dbserver
sudo rm -rf ../builds/webserver/tmp
sudo rm -rf ../builds/dbserver/tmp
sudo rm ../builds/webserver/docker_webserver.fc ../builds/webserver/docker_webserver.if ../builds/webserver/docker_webserver.pp
sudo rm ../builds/dbserver/docker_dbserver.fc ../builds/dbserver/docker_dbserver.if ../builds/dbserver/docker_dbserver.pp

# Delete seccomp ready files
sudo rm -rf ../builds/dbserver/output_h
sudo rm -rf ../builds/webserver/output_h