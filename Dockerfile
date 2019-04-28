FROM orvice/apache-base:71
MAINTAINER orvice<orvice@orx.me>


ENV VERSION 1.0
WORKDIR /var/www/html


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Install Supervisor.
RUN \
  apt-get update && \
  apt-get install -y supervisor git && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

# Define working directory.
WORKDIR /etc/supervisor/conf.d


RUN mkdir -p /var/log/supervisor && mkdir -p /etc/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


WORKDIR /var/www/html




# Copy Laravel App
ONBUILD COPY . /var/www/html




# Install dependencies with Composer.
ONBUILD RUN cd /var/www/html && composer install --no-scripts

ONBUILD RUN chmod -R 777 /var/www/html/storage


EXPOSE 80

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]


# Define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
