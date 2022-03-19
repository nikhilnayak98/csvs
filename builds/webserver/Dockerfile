# Webserver Dockerfile

FROM centos:7

LABEL org.opencontainers.image.authors="Nikhil Ranjan Nayak <Nikhil-Ranjan.Nayak@warwick.ac.uk>"

LABEL description="WebServer Image"

RUN 	yum install epel-release -y && \
	yum update -y && \
	yum install -y \
	nginx \
	php \
	php-mysqlnd \
	php-fpm \
	yum clean all && \
    rm -rf /var/cache/yum
	

COPY webfiles/ /usr/share/nginx/html

COPY configfiles/nginx.conf     /etc/nginx/nginx.conf
COPY configfiles/php.ini        /etc/php.ini
COPY configfiles/www.conf       /etc/php-fpm.d/www.conf
COPY configfiles/php-fpm.conf   /etc/nginx/conf.d/php-fpm.conf
COPY configfiles/docker-entrypoint.sh /

RUN rm -f /usr/share/nginx/html/index.html /usr/share/nginx/html/nginx-logo.png /usr/share/nginx/html/poweredby.png
RUN chmod +x /docker-entrypoint.sh && \
    chown apache:apache /usr/share/nginx/html/*.php && \
	mkdir -p /run/php-fpm && \
	mkdir -p /var/www/html && \
	mkdir -p /var/cache/nginx && \
	mkdir -p /run/nginx && \
	chown nginx:nginx /run/php-fpm -R && \
	chown nginx:nginx /run/nginx -R && \
	chmod a+rwX /run/nginx -R && \
	chown nginx:nginx /var/lib/php -R && \
	chown nginx:nginx /var/www -R && \
	chown nginx:nginx /var/log/php-fpm -R && \
	chown nginx:nginx /var/log/nginx -R && \
	setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx && \
	chown nginx:nginx /var/cache/nginx -R

EXPOSE 80

USER nginx

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]