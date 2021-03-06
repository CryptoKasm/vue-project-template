#!/bin/bash

# Variables
vNode="v12.21.0"

# Elevate privilages if not root
function checkRoot() { 
    if [ "$EUID" -ne 0 ]; then
        sudo echo -ne "\r"
    fi
}

# Pull ALL source
function gitPull() {
    git pull
    #git submodule update --init --recursive
}

# Install Curl package
function installCurl() {
    if ! [ -x "$(command -v curl)" ]; then
        sudo apt install curl -y

        if ! [ -x "$(command -v curl)" ]; then 
            echo "ERROR: CURL" 
        fi
    fi
}

# Install Node Version Manager
function installNVM() {
    if ! [ -x "$(command -v nvm)" ]; then
        curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
        source ~/.profile 
        nvm install $vNode
        nvm use $vNode 
        if ! [ -x "$(command -v nvm)" ]; then 
            echo "ERROR: Node Version Manager" 
        fi
    fi
}

# Install Vue Cli
function installVuecli() {
    if ! [ -x "$(command -v vue)" ]; then
        npm install -g @vue/cli
        if ! [ -x "$(command -v vue)" ]; then 
            echo "ERROR: Vue CLI" 
        fi
    fi
}

# Install NPM packages
function setupProject() {
    if ! [ -x "$(command -v npm)" ]; then
        sudo npm install
    fi
}

#############################
function mainSetup() {
    checkRoot
    gitPull
    setPermissions
    installCurl
    installNVM
    installVuecli
    setupProject
}
#############################
mainSetup