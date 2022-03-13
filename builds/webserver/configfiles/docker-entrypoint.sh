#!/bin/bash

# For stracing output, Citation: https://moodle.warwick.ac.uk/pluginfile.php/2256652/mod_folder/content/0/seccomp/build-minimal-sycalls.sh?forcedownload=1
# echo "waiting for /output_c/ready" 1>&2
# while [ ! -f /output_c/ready ]
# do
#     sleep 5
# done

# Citation: https://www.nixcraft.com/t/nginx-emerg-mkdir-var-lib-nginx-tmp-client-body-failed-2-no-such-file-or-directory/2916
mkdir -p /run/php-fpm/
mkdir -p /var/lib/nginx/tmp/
/usr/sbin/nginx
/usr/sbin/php-fpm -F
