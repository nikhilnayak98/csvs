#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/cdp
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Docker cleanup script.

# Delete all running containers
docker kill $(docker ps -a)
docker rm $(docker ps -a)

# Delete all voluments
docker volume prune -f