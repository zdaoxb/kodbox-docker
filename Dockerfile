FROM ubuntu:18.04
RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y tzdata \
    && ln -fs /usr/share/zoneinfo/US /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get install -y nginx-full sqlite redis unzip\
    && apt-get install -y php php-fpm php-curl php-gd php-mbstring php-redis php-sqlite3 php-pdo php-mysqli \
    && apt-get remove --purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*

COPY kodbox.1.18.zip /var/www/kodbox.zip
COPY kod.conf /etc/nginx/conf.d/
COPY run.sh /
RUN set -x \
    && rm /etc/nginx/sites-enabled/default \
    && chmod +x /run.sh \
    && cd /var/www \
    && unzip kodbox.zip -d kodbox \
    && chmod -Rf 777 kodbox \
    && rm kodbox.zip \
    && apt-get remove --purge -y --auto-remove unzip zip apache2\
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["./run.sh"]
