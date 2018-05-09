#!/usr/bin/env bash

set -e

./bash/hook/pre-deploy.sh "$@"

version=""
while getopts 'pv:' flag; do
    case "${flag}" in
        v) version="${OPTARG}" ;;
    esac
done

#docker stack deploy live --compose-file=docker-compose.live.yml

#docker deploy build/artifact

./bash/hook/post-deploy.sh "$@"
