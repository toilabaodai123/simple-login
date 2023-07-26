FROM webdevops/php-nginx:8.1

COPY . /app

COPY vhost.conf /opt/docker/etc/nginx

RUN chown -R nginx /app/storage \
    chown -R nginx:nginx /app \
    curl -sS https://getcomposer.org/installer \
    php -- --install-dir=/usr/local/bin --filename=composer 

WORKDIR /app

RUN composer install \
    useradd -ms /bin/bash newuser

EXPOSE 80

EXPOSE 443

USER newuser

WORKDIR /home/newuser
