#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/cdp
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Docker build script.

cd ../builds

# Build dbserver
cd dbserver
docker build . -t u2185920/csvs2022-db_i

cd ..

# Build webserver
cd webserver
docker build . -t u2185920/csvs2022-web_i