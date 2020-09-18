# docker_visual_modeling
Visual modeling analyses in R, in a docker container for version control and consistency.

## Overview
This repository creates a reproducible environment to run visual modeling analyses using the [*pavo*](https://cloud.r-project.org/web/packages/pavo/index.html) 2.4.0 package in *R* 4.0.0. A docker image is made using the [rocker/tidyverse:4.0.0](https://hub.docker.com/r/rocker/tidyverse) image, then downloading [*pavo*](https://cloud.r-project.org/web/packages/pavo/index.html) 2.4.0 from the CRAN archives.

Before building and running the docker container Rstudio environment, you must have [Docker](https://docs.docker.com/get-docker/) installed. Please be aware that the Docker image created will be 2.6GB in size. 

1. **Getting the repository onto your system**

Clone the repository onto your system by using the [Clone](https://github.com/aluro2/docker_visual_modeling/archive/master.zip) option on the Github page, or by opening a shell terminal and running git clone to clone the repo into the desired directory:

```git clone https://github.com/aluro2/docker_visual_modeling```

2. **Building and Running the Docker image and container**
Once the repo is cloned to your system, open a terminal, change into the directory of the repository, and run the *bash_scripts/build_and_run_docker_rstudio.sh* script to build the Docker image **visual_modeling_rstudio**, and run the docker container **visual_modeling_container**.

```
bash bash_scripts/build_and_run_docker_rstudio.sh
```

