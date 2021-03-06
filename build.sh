#!/bin/bash

# Check if all dependencies are found
function checkDependencies(){
    echo "Check Dependencies"
}

# Build distribution | Output Directory: /dist
function buildDist() {
    npm run build
}

# Build Dockerfile | Output Directory: 
function buildDockerfile() {
    source ./VERSION
    ImageName="$REPO:$VERSION"
    echo $ImageName
    docker build -t $ImageName .
}

#############################
function mainBuild() {
    checkDependencies
    buildDist
}
#############################
case "$1" in
    docker)
        buildDockerfile
        exit 0
        ;;
    *) 
        mainBuild
        exit 0
    ;;
esac
