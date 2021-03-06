#!/bin/bash

# Check if all dependencies are found
function checkDependencies(){
    ./bin/setup.sh
}

# Build distribution | Output Directory: /dist
function buildDist() {
    ./bin/build.sh
}

# Build Dockerfile | Output Directory: 
function buildDockerfile() {
    ./bin/build.sh docker
}

# Start docker with PARAMS
startDocker() {
    docker-compose up -d
}

#############################
function mainPreview() {
    checkDependencies
    buildDist
    buildDockerfile
    startDocker
}
#############################
mainPreview
