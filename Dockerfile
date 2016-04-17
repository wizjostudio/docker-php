FROM wizjostudio/ubuntu:latest
MAINTAINER Piotr Rzeczkowski <piotr@rzeka.net>

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    add-apt-repository ppa:ondrej/php5-5.6 && \
    apt-get update && \
    apt-get install -y \
        php5-fpm \
        php5-json \
        php5-curl \
        php5-gd \
        php5-imagick \
        php5-intl \
        php5-mcrypt \
        php5-memcached \
        php5-redis \
        php5-mysql \
        php5-xdebug && \
    php5dismod xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 100/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/listen\s*=\s*\/var\/run\/php5-fpm.sock/listen = 9000/g" /etc/php5/fpm/pool.d/www.conf

CMD ["php5-fpm", "-F"]

EXPOSE 9000
