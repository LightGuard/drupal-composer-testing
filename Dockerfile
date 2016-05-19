FROM developer.redhat.com/base
MAINTAINER Jason Porter <jporter@redhat.com>

ADD epel-release-latest-6.noarch.rpm epel-release-latest-6.noarch.rpm
ADD remi-release-6.rpm remi-release-6.rpm

RUN rpm -Uvh remi-release-6.rpm epel-release-latest-6.noarch.rpm
RUN yum-config-manager --enable remi-php70
RUN yum -y update; yum clean all
RUN yum -y install \
           git \
           httpd.x86_64 \
           mariadb \
           php \
           php-cli \
           php-common \
           php-gd \
           php-pdo \
           php-mbstring \
           php-mysql \
           php-mysqlnd \
           php-opcache \
           php-xml \
           tar \
           && yum clean all

RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /etc/php.d/opcache-recommended.ini

EXPOSE 80

RUN curl https://getcomposer.org/installer > composer-installer && php composer-installer && mv composer.phar /usr/local/bin/composer

ADD ./run-httpd.sh /run-httpd.sh
ADD ./drupal.conf /etc/httpd/conf.d/drupal.conf

RUN chown -R apache:apache /var/www/
RUN chmod -v +x /run-httpd.sh 

CMD ["/run-httpd.sh"]

