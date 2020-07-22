#!/bin/bash
#This script forces the db migrate to be run on the local mysql container

set -e

/home/app/webapp/bin/wait-for-it.sh list_view_postgres:5432

/home/app/webapp/bin/entrypoint.sh

bundle exec rake hl:localadmin

exec "$@"