#!/bin/sh

/etc/init.d/xvfb start && sleep 2

echo "Executing command $@"
exec "$@"