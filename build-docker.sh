#!/bin/bash

# Maven build and assemble.
appname="hello-world-api"
appsubmodule=
mvn_vtag=$(mvn help:evaluate -Dexpression=project.version 2> /dev/null | grep -e '^[^\[]')

# Build the runnable jar artifact.
mvn clean install -DskipTests

# Build docker image from assembled tarball.
#TODO perhaps switch/integrate to using maven's spotify or fabric8-maven-plugin plugin.
docker build --rm=true --force-rm=true --no-cache -t $appname:$mvn_vtag .

# Docker cleanup: Remove dangling images:
docker images -q --filter "dangling=true" | xargs -n1 docker rmi
