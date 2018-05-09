#!/usr/bin/env bash

set -e

project_name="${PWD##*/}-app"

if [ "$1" == "android" ] || [ "$1" == "ios" ] ; then
    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        rm --force --stop livesync_mobile

    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --detach --name livesync_mobile \
        native-cli npm run livesync.phone
fi

if [ "$1" == "android" ] ; then
    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --rm native-cli tns livesync android --watch
elif [ "$1" == "ios" ] ; then
    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --rm native-cli tns livesync ios --watch
elif [ "$1" == "web" ] ; then
    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --rm angular-cli ng serve "${@:2}"
fi
