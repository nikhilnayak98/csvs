#!/bin/bash
# 
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/csvs
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Docker one off run script.
#               (Citation 1: Peter Norris, https://moodle.warwick.ac.uk/pluginfile.php/2256652/mod_folder/content/0/selinux/docker_chat.te?forcedownload=1)
#               (Citation 2: Peter Norris, https://moodle.warwick.ac.uk/pluginfile.php/2256652/mod_folder/content/0/seccomp/build-minimal-sycalls.sh?forcedownload=1)
#               (Citation 3: Peter Norris, https://moodle.warwick.ac.uk/pluginfile.php/2256647/mod_folder/content/0/strip-image?forcedownload=1)

# Docker network
docker network create --subnet=198.51.100.0/24 u2185920/csvs2022_n

# Import database schema
docker exec -i u2185920_csvs2022-db_c mysql -uroot -pCorrectHorseBatteryStaple < ../builds/dbserver/sqlconfig/csvs22db.sql


#########################
# SELinux               #
#########################
# Compile textual file into an executable policy file
echo "csc" | sudo -S make -f /usr/share/selinux/devel/Makefile docker_dbserver.pp
echo "csc" | sudo -S make -f /usr/share/selinux/devel/Makefile docker_webserver.pp


# Insert the policy file into the active kernel policies to be used
sudo semodule -i docker_dbserver.pp
sudo semodule -i docker_webserver.pp

# Run containers with label
# Check for report policy contraventions
sudo cat /var/log/audit/audit.log

# Convert these contraventions to text which could be editted into .te file
sudo ausearch -m avc --start recent | audit2allow -r

# Ensure SELinux is enforcing
sudo setenforce 1


#########################
# SECCOMP               #
#########################
# Generate minimum syscalls to run the container
./build-minimal-sycalls.sh

# Stracing
echo "csc" | sudo -S strace -p $(docker inspect -f '{{.State.Pid}}' u2185920_csvs2022-db_c) -ff -o output_h/host-strace-output

echo "csc" | sudo -S strace -p $(docker inspect -f '{{.State.Pid}}' u2185920_csvs2022-web_c) -ff -o output_h/host-strace-output

# Set ready flag
echo "csc" | sudo -S touch output_h/ready

# Build syscalls
cat ../builds/webserver/output_h/* | \
    grep -Po "^[a-z_0-9]+\(" | \
    sed 's/(//' | \
    sort | \
    uniq > temp_assets/webserver/straced_syscalls

cat temp_assets/webserver/list-of-min-syscalls temp_assets/webserver/straced_syscalls | \
    sort | \
    uniq | \
    sed "s/^/\"/" | \
    sed "s/$/\",/" > temp_assets/webserver/min_syscalls

cat ../builds/dbserver/output_h/* | \
    grep -Po "^[a-z_0-9]+\(" | \
    sed 's/(//' | \
    sort | \
    uniq > temp_assets/dbserver/straced_syscalls

cat temp_assets/dbserver/list-of-min-syscalls temp_assets/dbserver/straced_syscalls | \
    sort | \
    uniq | \
    sed "s/^/\"/" | \
    sed "s/$/\",/" > temp_assets/dbserver/min_syscalls


#########################
# STRIPPING             #
#########################
# Install docker-slim
sudo curl -sL https://raw.githubusercontent.com/docker-slim/docker-slim/master/scripts/install-dockerslim.sh | sudo -E bash -

# dbserver stripping
../builds/dbserver/strip-cmd

# webserver stripping
../builds/webserver/strip-cmd