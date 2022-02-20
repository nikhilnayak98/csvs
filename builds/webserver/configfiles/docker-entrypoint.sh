#!/bin/bash

mkdir -p /run/php-fpm/
/usr/sbin/nginx
/usr/sbin/php-fpm -F
