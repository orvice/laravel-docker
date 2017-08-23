#!/bin/bash

set -e


echo 'Starting....'

cd /var/www/html && php artisan route:cache && php artisan view:clear

exec "$@"
