#!/usr/bin/env bash

set -e

project_name="${PWD##*/}-app"

#if [ "$1" == "android" ] || [ "$1" == "ios" ] ; then
#    livesync_name="$project_name-livesync_mobile"
#    echo "$livesync_name"
#    if [ -x "$(docker ps -a | grep -w "$livesync_name")" ]; then
#        echo "livesync_mobile is stopped"
#    else
#    if [ $(docker inspect -f '{{.State.Running}}' "$project_name-livesync_mobile") = "true" ] ; then
#    if [ ! "$(docker ps -a | grep livesync_mobile)" ]; then
#        echo ""
#    else
#        docker-compose \
#            -p "$project_name" \
#            -f docker-compose.yml \
#            -f ./compose/docker-compose.dev.yml \
#            rm --force --stop livesync_mobile
#    fi
#
#    docker-compose \
#        -p "$project_name" \
#        -f docker-compose.yml \
#        -f ./compose/docker-compose.dev.yml \
#        run --detach --service-ports --name livesync_mobile \
#        native-cli npm run livesync.phone
#fi

if [ "$1" == "android" ] ; then
    if [ "$(docker ps -a | grep livesync_android_watch)" ]; then
        docker-compose \
            -p "$project_name" \
            -f docker-compose.yml \
            -f ./compose/docker-compose.dev.yml \
            rm --force --stop livesync_android_watch
    fi

    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.android.yml \
        down

    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --detach --service-ports --name livesync_android_watch \
        native-cli tns run android

    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.android.yml \
        up -d
elif [ "$1" == "ios" ] ; then
    echo "Not supported yet."
elif [ "$1" == "web" ] ; then
    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --rm --service-ports angular-cli ng serve --host 0.0.0.0 "${@:2}"
fi
