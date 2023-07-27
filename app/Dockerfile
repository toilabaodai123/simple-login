FROM webdevops/php-nginx:8.1

COPY . /app

COPY vhost.conf /opt/docker/etc/nginx

RUN chown -R nginx:nginx /app \
    useradd -ms /bin/bash newuser

EXPOSE 80

EXPOSE 443

USER newuser

WORKDIR /home/newuser
