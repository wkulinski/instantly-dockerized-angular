#!/usr/bin/env bash

set -e

if [ -f bash/.create-lock ]; then
    echo "Project is already created. If you are sure you want to create it again pleas remove lock file bash/.create-lock. Keep in mind that re-creating project WILL lead to data loss. Exiting."
    exit 0
fi

PS3='Please choose project to create: '
options=("Only Angular" "Only NativeScript" "Angular and NativeScript using TeamMaestro/angular-native-seed" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Only Angular")
            type="angular"
            echo "Angular project will be created"
            break
            ;;
        "Only NativeScript")
            type="nativescript"
            echo "NativeScript project will be created"
            break
            ;;
        "Angular and NativeScript using TeamMaestro/angular-native-seed")
            type="angnat"
            echo "Angular and NativeScript project will be created (from seed)"
            break
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
if [ -z "$type" ]; then
    echo "Missing project type. Exiting."
    exit 1
fi

while read -p 'Pleas enter your email (for local git config): ' email && [[ -z "$email" ]] ; do
    printf "Pleas type some value.\n"
done

while read -p 'Pleas enter your full name (for local git config): ' name && [[ -z "$name" ]] ; do
    printf "Pleas type some value.\n"
done

./bash/install.sh "$@"

echo "Clearing project folder..."
sudo chown -R $USER:$USER angular/*
rm -Rf angular/nativescript/.gitkeep
rm -Rf angular/*
rm -Rf angular/.gitkeep

project_name="${PWD##*/}-app"
echo "Creating project..."

if [ "$type" = "angular" ] ; then
    echo "Creating new Angular project."

    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --workdir="/tmp" --rm angular-cli ng new "$project_name" --directory angular --style=scss

    sudo chown -R $USER:$USER angular/*
    echo "Done."
elif [ "$type" = "nativescript" ] ; then

    echo "Creating new NativeScript project."

    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --workdir="/tmp" --rm native-cli tns create nativescript --template tns-template-drawer-navigation-ng

#        run --workdir="/tmp" --rm native-cli tns create "$project_name" --ng --path nativescript/.

    sudo chown -R $USER:$USER angular/*

    echo "Adding android"

    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --rm native-cli tns platform add android

    echo "Moving new NativeScript project."
    
    echo "Done."
    echo "Sass installation."

    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --rm native-cli tns install sass

    sudo chown -R $USER:$USER angular/*
    echo "Done."
elif [ "$type" = "angnat" ] ; then
    echo "Cloning TeamMaestro/angular-native-seed repository"
    git clone https://github.com/TeamMaestro/angular-native-seed.git angular/.
    sudo chown -R $USER:$USER angular/*
    echo "Done."
    echo "Angular dependencies installation."

    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --rm angular-cli npm install

    echo "Done."
    echo "NativeScript dependencies installation."

    docker-compose \
        -p "$project_name" \
        -f docker-compose.yml \
        -f ./compose/docker-compose.dev.yml \
        run --rm native-cli npm install

    sudo chown -R $USER:$USER angular/*
    echo "Done."
fi

sudo chown -R $USER:$USER angular/*

echo "Creating git repository..."
git init

# Set name and email
git config user.name "$name"
git config user.email "$email"

# Make creation lock (this file should be commited into repository - there is no need to create once created project)
touch bash/.create-lock

# Make initial commit
git add .
git commit -m 'Initial commit'

echo "Project creation finished successfully."
echo "For more information pleas read README.md"
