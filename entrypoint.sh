#!/bin/bash -l

# TAG_NAME or SHORT_SHA
# PROJECT_ID
# ENVIRONMENT
# SVC_PREFIX

set -e

kustomize_edit_build() {
    local service=$1
    cd $SVC_PREFIX &&
    ls &&
    cd $service &&

    cd k8s/$ENVIRONMENT &&
    echo 'working in' $(pwd) &&
    kustomize edit set image $service=gcr.io/$PROJECT_ID/$service:$image_tag > /dev/null 2>&1 &&
    kustomize build > $dist/$service.yaml &&
    echo "$service manifest generated" &&
    cd $workspace
}

image_tag=""
dist=$(pwd)/dist
workspace=$(pwd)

mkdir -p $dist

if [ -z "$TAG_NAME" ]; then
    image_tag="$SHORT_SHA"
else
    image_tag="$TAG_NAME"
fi

echo "arguments: $1"
echo "working on: $image_tag"
echo "project: $PROJECT_ID"
echo "deploy to: $ENVIRONMENT"

for var in $(jq -r '.[]' <<< "$1"); do
    kustomize_edit_build $var
    result=$?
    if [ ! $result -eq 0 ]; then
        echo "error: $result"
        exit $result
    fi
done
