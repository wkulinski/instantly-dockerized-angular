#!/usr/bin/env bash

set -e

if [ ! -f bash/.create-lock ]; then
    echo "Project has to be created first."
    exit 1;
fi

./bash/hook/pre-build.sh "$@"

prod=false
version=""
fetch=true
system=web
mobile_command=""
while getopts 'pv:ns:a:' flag; do
    case "${flag}" in
        p) prod=true ;;
        v) version="${OPTARG}" ;;
        n) fetch=false ;;
        s) system="${OPTARG}" ;;
        m) mobile_command="${OPTARG}" ;;
    esac
done

. .env

if [ -z "$system" ] ; then
    PS3='Please choose on which system to make build: '
    options=("web" "android" "ios" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "web")
                system="web"
                echo "Web build will be executed"
                break
                ;;
            "android")
                system="android"
                if [ -z "$mobile_command" ] ; then
                    mobile_command="build.phone-android-bundle"
                fi
                echo "Android build will be executed"
                break
                ;;
            "ios")
                system="ios"
                if [ -z "$mobile_command" ] ; then
                    mobile_command="build.phone-ios-bundle"
                fi
                echo "IOS build will be executed"
                break
                ;;
            "Quit")
                break
                ;;
            *) echo invalid option;;
        esac
    done
    if [ -z "$system" ]; then
        echo "Missing system. Exiting."
        exit 1
    fi
fi

if [ "$system" == "web" ] ; then
    if [ -z "$DOCKER_REGISTRY_PATH" ] ; then
        while read -p 'Pleas enter registry domain/path (ie. localhost): ' DOCKER_REGISTRY_PATH && [[ -z "$DOCKER_REGISTRY_PATH" ]] ; do
            printf "Pleas type some value.\n"
        done

        echo "Updating .env file..."
        echo "DOCKER_REGISTRY_PATH=$DOCKER_REGISTRY_PATH" >> .env
        echo ".env file updated."
    fi

    if [ -z "$DOCKER_REGISTRY_PORT" ] ; then
        read -p "Pleas enter docker registry port (leave empty to use default 5000): " DOCKER_REGISTRY_PORT
        if [ -z "$DOCKER_REGISTRY_PORT" ]; then
            DOCKER_REGISTRY_PORT="5000"
        fi

        echo "Updating .env file..."
        echo "DOCKER_REGISTRY_PORT=$DOCKER_REGISTRY_PORT" >> .env
        echo ".env file updated."
    fi

    echo "Preparing build and push to $DOCKER_REGISTRY_PATH:$DOCKER_REGISTRY_PORT"

    if [ -z "$version" ] ; then
        if [ "$prod" == false ] ; then
            version="dev"
        else
            while read -p 'Pleas enter version number: ' version && [[ -z "$version" ]] ; do
                printf "Pleas type some value.\n"
            done
        fi
    fi
elif [ "$system" == "android" ] ; then

elif [ "$system" == "ios" ] ; then

fi

if [ "$fetch" == true ] ; then
    echo "Fetching remote repository..."
    git fetch

    if [ "$prod" = false ] ; then
        echo "Checking out to developement environment..."
        git checkout develop
        git reset --hard origin/develop
    else
        echo "Checking out to production environment..."
        git checkout master
        git reset --hard origin/master
    fi
    echo "Done."
fi

project_name="${PWD##*/}-build"

if [ "$system" == "web" ] ; then
    echo "Building images..."
    APPLICATION_VERSION="$version" docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.build.yml \
        build
    echo "Images build finished."

    rm -Rf node_modules/* node_modules/.*
    docker-compose -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.build.yml \
        run --rm angular-cli npm install

    rm -Rf dist/* dist/.*
    if [ "$prod" == false ] ; then
        docker-compose -p "$project_name" \
            -f docker-compose.yml \
            -f ./compose/docker-compose.build.yml \
            run --rm angular-cli ng build --build-optimizer --aot
    else
        docker-compose -p "$project_name" \
            -f docker-compose.yml \
            -f ./compose/docker-compose.build.yml \
            run --rm angular-cli ng build --prod --build-optimizer --aot
    fi

    chown -R www-data:www-data .

    echo "Re-building app image..."
    APPLICATION_VERSION="$version" docker-compose \
        -p "$project_name" \
        -f docker-compose.build.yml \
        -f ./compose/docker-compose.build.yml \
        build app
    echo "App image build finished."

    echo "Login to $DOCKER_REGISTRY_PATH:$DOCKER_REGISTRY_PORT registry path."
    docker login "$DOCKER_REGISTRY_PATH:$DOCKER_REGISTRY_PORT"

    echo "Pushing to registry..."
    APPLICATION_VERSION="$version" docker-compose \
        -p "$project_name" \
        -f docker-compose.build.yml \
        -f ./compose/docker-compose.build.yml \
        push
    echo "Push finished."

    echo "Build finished."
elif [ "$system" == "android" ] ; then
    docker-compose -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.build.yml \
        run --rm native-cli npm run "$mobile_command"
elif [ "$system" == "ios" ] ; then
    docker-compose -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.build.yml \
        run --rm native-cli npm run "$mobile_command"
fi

./bash/hook/post-build.sh "$@"
