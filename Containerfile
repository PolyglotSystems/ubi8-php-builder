FROM registry.access.redhat.com/ubi8/ubi:latest as BUILDER

# Setup Default Args
ARG PHP_VERSION=7.4
ARG SOURCE_NAME

USER root

# Our command is set to bash to allow for easy build piping
CMD [ "/bin/bash" ]

# Environmental Variables
ENV PATH=/opt/app-root/bin/:$PATH

# Update image
RUN yum update -y --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos \
 && yum -y module enable php:$PHP_VERSION \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm -rf /var/log/*

# Install NPM and PHP
RUN yum install -y --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos npm nodejs nginx nodejs-devel autoconf automake binutils gcc gcc-c++ gdb glibc-devel libtool make pkgconf pkgconf-m4 pkgconf-pkg-config redhat-rpm-config rpm-build-libs git wget curl php php-fpm php-cli php-pgsql php-devel php-xml php-json php-pdo php-mysqlnd php-bcmath php-gd php-xmlrpc php-soap php-mbstring \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm -rf /var/log/*

# Clear Image
RUN rm -rf /var/www/html \
 && mkdir -p /var/www/html \
 && mkdir -p /opt/app-root/{bin,src} \
 && mkdir -p /var/{log,run}/{nginx,php-fpm} \
 && touch /var/log/nginx/error.log \
 && chown -R 1001:1001 /opt/app-root \
 && chown -R 1001:1001 /var/www/ \
 && chown -R 1001:1001 /var/{log,run}/{nginx,php-fpm}/ \
 && chmod -R 777 /var/{log,run}/{nginx,php-fpm}/ \
 && chmod -R 777 /var/www/

# Get Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php \
 && php -r "unlink('composer-setup.php');" \
 && mv composer.phar /opt/app-root/bin/composer \
 && chmod +x /opt/app-root/bin/composer

WORKDIR "/var/www/html"

USER 1001

## Finished building application