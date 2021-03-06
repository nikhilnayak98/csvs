#!/bin/bash
#
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/csvs
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Find minimal syscalls for containers by removing from min syscalls that are already generated
#              (Citation: Peter Norris, https://moodle.warwick.ac.uk/pluginfile.php/2256652/mod_folder/content/0/seccomp/build-minimal-sycalls.sh?forcedownload=1)

# For dbserver
cp temp_assets/dbserver/min-syscalls.json temp_assets/dbserver/temp-min-syscalls.json
while read s
do
    echo "$s being removed from min-syscalls.json"
    grep -vw "\"${s}\"" temp_assets/dbserver/temp-min-syscalls.json > temp_assets/dbserver/tmp.json
    docker rm -f u2185920_csvs2022-db_c
    docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.179 \
        --hostname db.cyber22.test \
        -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" \
        -e MYSQL_DATABASE="csvs22db" \
        --cpuset-cpus=0 \
        --memory="300m" \
        --memory-swap="1g" \
        --read-only \
        --tmpfs /tmp \
        --tmpfs /var \
        --tmpfs /var/run/mysqld \
        --tmpfs /var/lib/mysqld \
        --tmpfs /run/mysqld \
        -v DBSERVERDATA_VOL:/var/lib/mysql/:rw \
        --cap-drop=ALL \
        --security-opt=no-new-privileges \
        --security-opt seccomp:temp_assets/dbserver/tmp.json \
        --name u2185920_csvs2022-db_c u2185920/csvs2022-db_i
    sleep 5
    
    curl -s --max-time 5 -X POST http://localhost/action.php \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d 'fullname='"$s"'&feedback=can be removed'
    
    if [ $( curl --max-time 5 -s http://localhost/index.php | grep -w ${s} | wc -l ) == "1" ]
    then
        cp temp_assets/dbserver/tmp.json temp_assets/dbserver/temp-min-syscalls.json
        echo "$s can be removed"
    else
        echo $s >> temp_assets/dbserver/reduced_min_syscalls
    fi
done < temp_assets/dbserver/min_syscalls

# For webserver
cp temp_assets/webserver/min-syscalls.json temp_assets/webserver/temp-min-syscalls.json
while read s
do
    echo "$s being removed from min-syscalls.json"
    grep -vw "\"${s}\"" temp_assets/webserver/temp-min-syscalls.json > temp_assets/webserver/tmp.json
    docker rm -f u2185920_csvs2022-web_c
    docker run -d \
        --net u2185920/csvs2022_n \
        --ip 198.51.100.180 \
        --hostname www.cyber22.test \
        --add-host db.cyber22.test:198.51.100.179 \
        -p 80:80 \
        --cpuset-cpus=0 \
        --memory="100m" \
        --memory-swap="300m" \
        --read-only \
        --tmpfs /var/log/nginx \
        --tmpfs /var/log/php-fpm \
        --tmpfs /var/lib/nginx/tmp \
        --tmpfs /var/run/php-fpm \
        --tmpfs /run \
        --cap-drop=ALL \
        --cap-add=CHOWN --cap-add=SETGID --cap-add=SETUID --cap-add=NET_BIND_SERVICE \
        --security-opt=no-new-privileges \
        --security-opt seccomp:temp_assets/webserver/tmp.json \
        --name u2185920_csvs2022-web_c u2185920/csvs2022-web_i
    sleep 5
    if [ $( curl --max-time 5 -s http://localhost/index.php | grep wm00i | wc -l ) == "1" ]
    then
        cp temp_assets/webserver/tmp.json temp_assets/webserver/temp-min-syscalls.json
        echo "$s can be removed"
    else
        echo $s >> temp_assets/webserver/reduced_min_syscalls
    fi
done < temp_assets/webserver/min_syscalls

rm temp_assets/webserver/tmp.json temp_assets/webserver/temp-min-syscalls.json
rm temp_assets/dbserver/tmp.json temp_assets/dbserver/temp-min-syscalls.json