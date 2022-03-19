#!/bin/bash
#
# Author: Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/csvs
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Find minimal selinux rules for containers by removing from each rule that is already generated

# For dbserver
cd temp_assets/selinux/dbserver
while read rule
do
    echo "$rule being removed from docker_dbserver.te"
    grep -vw "$rule" docker_dbserver_file > tmp_docker_dbserver.te
    docker rm -f u2185920_csvs2022-db_c
    echo "csc" | sudo -S semodule -r tmp_docker_dbserver
    echo "csc" | sudo -S make -f /usr/share/selinux/devel/Makefile tmp_docker_dbserver.pp
    echo "csc" | sudo -S semodule -i tmp_docker_dbserver.pp
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
        --tmpfs /var/run/mysqld \
        --tmpfs /var/lib/mysqld \
        --tmpfs /run/mysqld \
        -v DBSERVERDATA_VOL:/var/lib/mysql/:rw \
        --cap-drop=ALL \
        --security-opt=no-new-privileges \
        --security-opt label:type:tmp_docker_dbserver_t \
        --name u2185920_csvs2022-db_c u2185920/csvs2022-db_i:stripped

    sleep 5

    curl -s --max-time 5 -X POST http://localhost/action.php \
       -H "Content-Type: application/x-www-form-urlencoded" \
       -d 'fullname='"$rule"'&feedback=can be removed'
    
    if [ $( curl --max-time 5 -s http://localhost/index.php | grep -w "$rule" | wc -l ) == "1" ]
    then
        cp tmp_docker_dbserver.te docker_dbserver_file
        echo "$rule can be removed"
    else
        echo $rule >> min_rules
    fi
    echo "csc" | sudo -S rm -rf tmp
    echo "csc" | sudo -S rm tmp_docker_dbserver.fc tmp_docker_dbserver.if tmp_docker_dbserver.pp
done < avc_rules

echo "csc" | sudo -S semodule -r tmp_docker_dbserver
rm tmp_docker_dbserver.te


# For webserver
cd temp_assets/selinux/webserver
while read rule
do
    echo "$rule being removed from docker_webserver.te"
    grep -vw "$rule" docker_webserver_file > tmp_docker_webserver.te
    docker rm -f u2185920_csvs2022-web_c
    echo "csc" | sudo -S semodule -r tmp_docker_webserver
    echo "csc" | sudo -S make -f /usr/share/selinux/devel/Makefile tmp_docker_webserver.pp
    echo "csc" | sudo -S semodule -i tmp_docker_webserver.pp
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
        --security-opt label:type:tmp_docker_webserver_t \
        --name u2185920_csvs2022-web_c u2185920/csvs2022-web_i:stripped
    sleep 5
    if [ $( curl --max-time 5 -s http://localhost/index.php | grep wm00i | wc -l ) == "1" ]
    then
        cp tmp_docker_webserver.te docker_webserver_file
        echo "$rule can be removed"
    else
        echo $rule >> min_rules
    fi
    echo "csc" | sudo -S rm -rf tmp
    echo "csc" | sudo -S rm tmp_docker_webserver.fc tmp_docker_webserver.if tmp_docker_webserver.pp
done < avc_rules

echo "csc" | sudo -S semodule -r tmp_docker_webserver
rm tmp_docker_webserver.te