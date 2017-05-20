#!/bin/bash

# from https://github.com/fr3nd/docker-supervisor/blob/master/supervisord.conf

set -e

# ln -s /etc/supervisor/supervisord.conf /etc/supervisord.conf

if [ -z "$@" ]; then
  exec /usr/local/bin/supervisord -c /etc/supervisord.conf --nodaemon
else
  exec PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin $@
fi
