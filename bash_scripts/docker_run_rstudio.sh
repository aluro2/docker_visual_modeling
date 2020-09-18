#!/usr/bin/env bash

echo "Starting temporary docker container. No changes to container will be saved upon stoppping container!"

# Run Temporary Docker Container
docker run --rm -d -p 8787:8787 -v $(pwd):/home/rstudio -e DISABLE_AUTH=true --name visual_modeling_container  visual_modeling_rstudio

echo "Container ready! Go to http://localhost:8787 (on Linux OS) or http://<your ip address here>:8787 (Windows and Mac OS) to enter RStudio session"