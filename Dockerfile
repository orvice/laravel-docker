FROM orvice/apache-base
MAINTAINER orvice<orvice@orx.me>


ENV VERSION 1.0
WORKDIR /var/www/html

# Install sspanel
COPY . /var/www/html


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies with Composer.
ONBUILD RUN cd /var/www/html && composer install --no-scripts

ONBUILD RUN chmod -R 777 storage

 ## Supervisor
## Install
RUN \
  apt-get update && \
  apt-get install -y supervisor cron vim && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

# Define working directory.
WORKDIR /etc/supervisor/conf.d


RUN mkdir -p /var/log/supervisor
#COPY supervisor /etc/supervisor/conf.d/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
VOLUME /var/log/supervisor

WORKDIR /var/www/html


EXPOSE 80

#ENTRYPOINT ["/entrypoint.sh"]
# Define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]