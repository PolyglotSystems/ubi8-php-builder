FROM registry.access.redhat.com/ubi8/ubi:latest as BUILDER

# Setup Default Args
ARG PHP_VERSION=7.4
ARG SOURCE_NAME

USER root

# Our command is set to bash to allow for easy build piping
CMD [ "/bin/bash" ]

# Environmental Variables
ENV COPY_ENV_FILE=true \
    GENERATE_ENV_KEY=true \
    GENERATE_SQLITE_DB=true \
    MIGRATE_DATABASE=true \
    SEED_DATABASE=true \
    COPY_ENV_FILE_FROM_CONFIGMAP=false \
    GENERATE_SHOW_NEW_ENV_KEY=false \
    PATH=/opt/app-root/bin/:$PATH

# Update image
RUN yum update -y --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos \
 && yum -y module enable php:$PHP_VERSION \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm -rf /var/log/*

# Install NPM and PHP
RUN yum install -y --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos npm nodejs nodejs-devel autoconf automake binutils gcc gcc-c++ gdb glibc-devel libtool make pkgconf pkgconf-m4 pkgconf-pkg-config redhat-rpm-config rpm-build-libs git wget curl php php-fpm php-cli php-pgsql php-devel php-xml php-json php-pdo php-mysqlnd php-bcmath php-gd php-xmlrpc php-soap php-mbstring \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm -rf /var/log/*

# Clear Image
RUN rm -rf /var/www/html \
 && mkdir -p /var/www/html/public \
 && mkdir -p /var/log/php-fpm \
 && mkdir -p /opt/app-root/bin

# Get Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php \
 && php -r "unlink('composer-setup.php');" \
 && mv composer.phar /opt/app-root/bin/composer

# Copy files
#COPY builder-root/ /
#COPY app-src/ /var/www/html/
#COPY .git/refs/heads/main /var/www/html/storage/.gitchecksum

WORKDIR "/var/www/html"

USER 1001

## Finished building application