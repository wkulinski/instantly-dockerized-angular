#!/usr/bin/env bash

set -e

compose="dev"
activity="reload"
while getopts 'c:a:' flag; do
  case "${flag}" in
    c) compose="${OPTARG}" ;;
    a) activity="${OPTARG}" ;;
  esac
done

if [ "$activity" != "delete" ] ; then
    project_name=${PWD##*/}

    if [ "$compose" = "deploy" ] ; then
        project_name="$project_name-app"
        echo "Using deploy docker-compose"
        composer_file="./compose/docker-compose.deploy.yml"
    elif [ "$compose" = "build" ] ; then
        project_name="$project_name-app"
        echo "Using build docker-compose"
        composer_file="./compose/docker-compose.build.yml"
    else
        project_name="$project_name-app"
        echo "Using dev docker-compose"
        composer_file="./compose/docker-compose.dev.yml"
    fi
fi

if [ "$activity" = "reload" ] ; then
    echo "Reloading docker containers..."
    COMPOSE_IGNORE_ORPHANS=1 docker-compose -p "$project_name" -f docker-compose.yml -f "$composer_file" down
    COMPOSE_IGNORE_ORPHANS=1 docker-compose -p "$project_name" -f docker-compose.yml -f "$composer_file" build
    COMPOSE_IGNORE_ORPHANS=1 docker-compose -p "$project_name" -f docker-compose.yml -f "$composer_file" up -d
    echo "Docker containers reloaded."
elif [ "$activity" = "down" ] ; then
    echo "Containers down..."
    echo "Stops containers and removes containers, networks, volumes, and images created by 'ins manage up'."
    COMPOSE_IGNORE_ORPHANS=1 docker-compose -p "$project_name" -f docker-compose.yml -f "$composer_file" down
    echo "Done."
elif [ "$activity" = "stop" ] ; then
    echo "Containers stop..."
    echo "Stops running containers without removing them. They can be started again with 'ins manage start'"
    COMPOSE_IGNORE_ORPHANS=1 docker-compose -p "$project_name" -f docker-compose.yml -f "$composer_file" stop
    echo "Done."
elif [ "$activity" = "rm" ] ; then
    echo "Containers remove..."
    echo "Removes stopped service containers."
    COMPOSE_IGNORE_ORPHANS=1 docker-compose -p "$project_name" -f docker-compose.yml -f "$composer_file" rm
    echo "Done."
elif [ "$activity" = "build" ] ; then
    echo "Services build..."
    echo "Services are built once and then tagged, by default as project_service. For example, composetest_db."
    COMPOSE_IGNORE_ORPHANS=1 docker-compose -p "$project_name" -f docker-compose.yml -f "$composer_file" up -d
    echo "Done."
elif [ "$activity" = "up" ] ; then
    echo "Containers up..."
    echo "Builds, (re)creates, starts, and attaches to containers for a service."
    COMPOSE_IGNORE_ORPHANS=1 docker-compose -p "$project_name" -f docker-compose.yml -f "$composer_file" up -d
    echo "Done."
elif [ "$activity" = "start" ] ; then
    echo "Containers start..."
    echo "Starts existing containers for a service."
    COMPOSE_IGNORE_ORPHANS=1 docker-compose -p "$project_name" -f docker-compose.yml -f "$composer_file" start
    echo "Done."
elif [ "$activity" = "logs" ] ; then
    echo "Containers start..."
    echo "Starts existing containers for a service."
    COMPOSE_IGNORE_ORPHANS=1 docker-compose -p "$project_name" -f docker-compose.yml -f "$composer_file" logs
    echo "Done."
elif [ "$activity" = "delete" ] ; then
    read -p "Are you sure you want remove ALL docker containers on host machine (docker-compose will be ignored)? [Y/n]" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
    fi

    echo "Removing ALL docker containers on machine..."
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    echo "ALL docker containers removed."
fi
