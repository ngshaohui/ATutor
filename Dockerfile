FROM php:5.4-apache

COPY ATutor-2.2.1.tar.gz /tmp
# use strip components to remove outermost ATutor folder
# /var/www/html/ATutor/index.php becomes /var/www/html/index.php
RUN tar -xzf /tmp/ATutor-2.2.1.tar.gz -C /var/www/html/ --strip-components=1

# cleanup
RUN rm /tmp/ATutor-2.2.1.tar.gz
RUN rm -rf /tmp/ATutor

# jessie has been moved to archive, need to update the sources.list accordingly
RUN rm /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list.d/jessie.list
RUN echo "deb http://archive.debian.org/debian jessie main" >> /etc/apt/sources.list.d/jessie.list

# need to install the following to install the gd extension
# libfreetype-dev omitted since it can no longer be found
# don't think that --with-jpeg flag is working, but ATutor only shows a warning so will not bother fixing
RUN apt-get update && apt-get install -y --allow-unauthenticated \
		# libfreetype-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg

# extensions
# use pdo_mysql instead of just mysql as it is not a valid extension
# Possible values for ext-name:
# bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd gettext gmp hash iconv imap interbase intl json ldap mbstring mcrypt mssql mysql mysqli oci8 odbc pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline recode reflection session shmop simplexml snmp soap sockets spl standard sybase_ct sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl zip
RUN docker-php-ext-install mysql mbstring gd && docker-php-ext-enable mysql mbstring gd

# prematurely resolve errors when setting up ATutor
RUN mkdir content && \
        chmod 2777 content && \
        chmod a+rw include/config.inc.php
