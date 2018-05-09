#!/usr/bin/env bash

echo "Current PATH is $PATH"
if [[ ! $PATH = *"$PWD"* ]]; then
    pathvariable='$PATH'
    echo "Exporting PATH=$pathvariable:$PWD"

    if [ -f ~/.bashrc ]; then
        if [ ! -f ~/.bash_profile ]; then
            touch ~/.bash_profile
            echo "~/.bash_profile created."
        fi

        grep -q -F 'source $HOME/.bashrc' ~/.bash_profile || echo 'source $HOME/.bashrc' >> ~/.bash_profile
        source ~/.bash_profile

        grep -q -F "export PATH=$pathvariable:$PWD" ~/.bashrc || echo "export PATH=$pathvariable:$PWD" >> ~/.bashrc
        source ~/.bashrc

        echo "Path exported."
    else
        echo "Unable to locate ~/.bashrc file"
    fi
else
    echo "Path is already exported."
fi