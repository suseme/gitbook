#!/usr/bin/env bash

###############################################################################
# Copyright 2020 RB. All Rights Reserved.
# Author: vin(vin@misday.com)
###############################################################################

function mis_gitbook()
{
    ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/" && pwd -P)"
    GITBOOK_IMAGE="mis_gitbook:1.0"

    DOCKERFILE="$ROOT_DIR/Dockerfile"
    TAG="$GITBOOK_IMAGE"
    CONTEXT="$ROOT_DIR"

    # print_delim
    echo "|  Docker build ${TAG}"
    echo "|      using dockerfile=${DOCKERFILE}"
    echo "|      context=${CONTEXT}"
    # print_delim

    docker build \
        -f "${DOCKERFILE}" "${CONTEXT}" \
        -t "${TAG}" \
        --network host
    #    --build-arg HTTP_PROXY=http://127.0.0.1:3128 \
    #    --build-arg HTTPS_PROXY=http://127.0.0.1:3128

    echo "Built new image ${TAG}"
}

DOCKER_IMG=fellah/gitbook

case $1 in
    mis)
        mis_gitbook
        ;;
    img)
        docker pull $DOCKER_IMG
        ;;
    plugin)
        docker run -v $PWD:/srv/gitbook -v $PWD/docs:/srv/html --network=host $DOCKER_IMG gitbook install
        ;;
    svr)
        docker run -p 4000:4000 -v $PWD:/srv/gitbook -v $PWD/docs:/srv/gitbook/_book $DOCKER_IMG gitbook serve ./
        ;;
    html)
        docker run -v $PWD:/srv/gitbook -v $PWD/docs:/srv/html $DOCKER_IMG gitbook build . /srv/html
        ;;
    pdf)
        docker run -v $PWD:/srv/gitbook -v $PWD/docs:/srv/html -v $PWD/../fonts:/usr/share/fonts $DOCKER_IMG gitbook pdf . /srv/html/$2.pdf
        ;;
    epub)
        docker run -v $PWD:/srv/gitbook -v $PWD/docs:/srv/html $DOCKER_IMG gitbook epub . /srv/html/$2.epub
        ;;
    mobi)
        docker run -v $PWD:/srv/gitbook -v $PWD/docs:/srv/html $DOCKER_IMG gitbook mobi . /srv/html/$2.mobi
        ;;
    *)
        echo "$0 img|plugin|html|pdf|epub|mobi"
        ;;
esac
