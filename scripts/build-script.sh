#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/csvs
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Docker build script.

BUILDSDIR=$(cd ../builds && pwd)

# Build dbserver
cd $BUILDSDIR/dbserver
docker build . -t u2185920/csvs2022-db_i

# Build webserver
cd $BUILDSDIR/webserver
docker build . -t u2185920/csvs2022-web_i