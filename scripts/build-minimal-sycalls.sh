#!/bin/bash
#
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/csvs
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Find minimal syscalls by removing from default syscalls
#              (Citation: Peter Norris, https://moodle.warwick.ac.uk/pluginfile.php/2256652/mod_folder/content/0/seccomp/build-minimal-sycalls.sh?forcedownload=1)

while read s
do
    echo "$s being removed from moby-default.json"
    grep -v "\"${s}\"" temp_assets/moby-default.json > temp_assets/tmp.json
    docker run --rm --security-opt seccomp:temp_assets/tmp.json centos:7 true || echo $s >> temp_assets/list-of-min-syscalls

done < temp_assets/moby-syscalls
