#!/usr/bin/env bash

echo "Building docker image"

# Build docker image using docker buildkit
DOCKER_BUILDKIT=1 docker build -t visual_modeling_rstudio .

echo "Visual modeling Rstudio image ready!"

