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
echo "csc" | sudo -S semodule -r docker_dbserver
echo "csc" | sudo -S rm -rf ../builds/webserver/tmp
echo "csc" | sudo -S rm -rf ../builds/dbserver/tmp
echo "csc" | sudo -S rm ../builds/webserver/docker_webserver.fc ../builds/webserver/docker_webserver.if ../builds/webserver/docker_webserver.pp
echo "csc" | sudo -S rm ../builds/dbserver/docker_dbserver.fc ../builds/dbserver/docker_dbserver.if ../builds/dbserver/docker_dbserver.pp

# Delete seccomp ready files
echo "csc" | sudo -S rm -rf ../builds/dbserver/output_h
echo "csc" | sudo -S rm -rf ../builds/webserver/output_h