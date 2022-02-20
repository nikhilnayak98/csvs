# University of Warwick: Peter Norris: Feb 2022

# You will find two folders in this archive, one for a database container and one for a webserver container.
# This README file provides you with the commands to get the web application working in the most basic configuration.
# in all the following, replace u2185920 with your specific university ID.

####### Docker Network ############

# So that our containers can talk to each other, we need to create a docker network:

docker network create --subnet=198.51.100.0/24 u2185920/csvs2022_n

####### DATABASE (MySQL) ###########

# First build the database image from the supplied docker file.

# Build dbserver
docker build . -t u2185920/csvs2022-db_i

# Name your image u2185920/csvs2022-db_i  (but replace u2185920 with your own university id)
# (tag as 0.1, 0.2 as well as latest if you feel this to be essential).
# After building the MYSQL image from the dockerfile you can use the following run-time command to get started:

docker run -d --net u2185920/csvs2022_n --ip 198.51.100.179 --hostname db.cyber22.test -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" -e MYSQL_DATABASE="csvs22db" --name u2185920_csvs2022-db_c u2185920/csvs2022-db_i 

# After running this command, your mysql container will not be configured with a database.
# Therefore everytime you start your mysql container you need to run the following command in order to prepare the database:

docker exec -i u2185920_csvs2022-db_c mysql -uroot -pCorrectHorseBatteryStaple < sqlconfig/csvs22db.sql

# This will create a pre-configured database which can be used by the web application.

# NOTE 1: there should be no space between "-p" and your password (for example -ptest )
# NOTE 2: You will receive a MYSQL error if you attempt to run the 'docker exec' command too quickly after starting the container with 'docker run'. Wait for a few seconds so that database can get started.
# HINT: Importing your database everytime you start the container is not efficient... Think how you can make this data persist!
# NOTE 3: For information on the database image, see the following URL: https://hub.docker.com/_/mariadb

###### WEBSERVER (nginx)

# FIrst build the webserver image from the supplied dockerfile

# Build webserver
docker build . -t u2185920/csvs2022-web_i

# Name your image u2185920/csvs2022-web_i  (but replace u2185920 with your own university id)
# After building the NGINX dockerfile you can use the following run-time command to get started:

docker run -d --net u2185920/csvs2022_n --ip 198.51.100.180 --hostname www.cyber22.test --add-host db.cyber22.test:198.51.100.179 -p 80:80 --name u2185920_csvs2022-web_c u2185920/csvs2022-web_i

# You should now be able to browse to http://localhost/ to view the web application!

# NOTE: If you have issues getting the basic setup working, ask for help!


