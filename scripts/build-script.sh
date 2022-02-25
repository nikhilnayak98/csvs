#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/cdp
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Docker build script.

# Build dbserver
docker build . -t u2185920/csvs2022-db_i

# Build webserver
docker build . -t u2185920/csvs2022-web_i