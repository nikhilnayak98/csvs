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
echo "csc" | sudo -S sudo make -f /usr/share/selinux/devel/Makefile docker_dbserver.pp
echo "csc" | sudo -S sudo make -f /usr/share/selinux/devel/Makefile docker_webserver.pp


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
./build-minimal-sycalls.sh

# Stracing
sudo strace -p $(docker inspect -f '{{.State.Pid}}' u2185920_csvs2022-web_c) -ff -o output_h/host-strace-output 

# Set ready flag
sudo touch output_h/ready

# Build syscalls
mkdir 
cat ../builds/webserver/output_h/* | grep -Po "^[a-z_0-9]+\(" | sed 's/(//' | sort | uniq | sed "s/$/\"/" | sed "s/^/\"/" > temp_assets/webserver/syscalls
cat temp_assets/webserver/list-of-min-syscalls temp_assets/webserver/syscalls | sort | uniq | sed "s/$/,/" > temp_assets/webserver/minsyscalls

cat ../builds/dbserver/output_h/* | grep -Po "^[a-z_0-9]+\(" | sed 's/(//' | sort | uniq | sed "s/$/\"/" | sed "s/^/\"/" > temp_assets/dbserver/syscalls
cat temp_assets/dbserver/list-of-min-syscalls temp_assets/dbserver/syscalls | sort | uniq | sed "s/$/,/" > temp_assets/dbserver/minsyscalls