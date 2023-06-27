FROM webdevops/php-nginx:8.1

COPY . /app

COPY vhost.conf /opt/docker/etc/nginx

RUN chown -R nginx /app/storage

USER nginx
