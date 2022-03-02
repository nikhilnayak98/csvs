#!/bin/bash

# Citation: https://www.nixcraft.com/t/nginx-emerg-mkdir-var-lib-nginx-tmp-client-body-failed-2-no-such-file-or-directory/2916
mkdir -p /run/php-fpm/
mkdir -p /var/lib/nginx/tmp/
/usr/sbin/nginx
/usr/sbin/php-fpm -F
