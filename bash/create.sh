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
rm -Rf angular/*
rm -Rf angular/.gitkeep

project_name="${PWD##*/}-app"
echo "Creating project..."

if [ "$type" = "angular" ] ; then
    docker-compose -p "$project_name" -f docker-compose.yml -f ./compose/docker-compose.dev.yml run --rm angular-cli ng new . --style=scss
elif [ "$type" = "nativescript" ] ; then
    docker-compose -p "$project_name" -f docker-compose.yml -f ./compose/docker-compose.dev.yml run --rm native-cli tns create . --ng
    docker-compose -p "$project_name" -f docker-compose.yml -f ./compose/docker-compose.dev.yml run --rm native-cli tns install sass
elif [ "$type" = "angnat" ] ; then
    git clone https://github.com/TeamMaestro/angular-native-seed.git angular/.
    docker-compose -p "$project_name" -f docker-compose.yml -f ./compose/docker-compose.dev.yml run --rm angular-cli npm install
    docker-compose -p "$project_name" -f docker-compose.yml -f ./compose/docker-compose.dev.yml run --rm native-cli npm install
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
