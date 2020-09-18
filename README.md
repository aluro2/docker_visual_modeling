# Dockerized Visual Modeling in R
Visual modeling analyses in R, in a docker container for version control and consistency.

## Overview
This repository creates a reproducible environment to run visual modeling analyses using the [*pavo*](https://cloud.r-project.org/web/packages/pavo/index.html) 2.4.0 package in *R* 4.0.0. A docker image is made using the [rocker/tidyverse:4.0.0](https://hub.docker.com/r/rocker/tidyverse) image, then downloading [*pavo*](https://cloud.r-project.org/web/packages/pavo/index.html) 2.4.0 from the CRAN archives. Before building and running the docker container Rstudio environment, you must have [Docker](https://docs.docker.com/get-docker/) installed. Please be aware that the Docker image created will be 2.6GB in size. 

### Getting the repository onto your system

- Clone the repository onto your system by  [downloading](https://github.com/aluro2/docker_visual_modeling/archive/master.zip) the repo from Github, or by opening a shell terminal and running git clone to clone the repo into the desired directory.

```git clone https://github.com/aluro2/docker_visual_modeling```

### Building and running the Docker image and container
- Once the repo is cloned to your system, open a terminal, change into the directory of the repository, and run the *bash_scripts/build_and_run_docker_rstudio.sh* script to build the Docker image **visual_modeling_rstudio**, and run the docker container **visual_modeling_container**.

```bash bash_scripts/build_and_run_docker_rstudio.sh```

- It will take a few minutes for the Docker image to be built and the container to be active. When the container is ready and active, open a web browser and go to http://localhost:8787 (for Linux OS) or ```http://<your local ip address>:8787``` (for Windows and Mac OS) to open the RStudio session.

- You should see an active RStudio session in your web browser. If not, double-check to make sure you have the correct ip address for your local server. 

- The active container will have access to all of the files in your local directory *docker_visual_modeling*. To run analyses using your own data, create a new folder in the *docker_visual_modeling/analysis* directory and import your data into it. 

- When finished with your RStudio session, close the web browser, open a terminal and run ``docker stop visual_modeling_container`` to stop the container and delete it. Any changes made to the container (e.g., downloading an R package or updating R) will be lost as the containers are ephemeral. 

#### R packages
- If you need to temporarily use packages that are not already available in the Docker container, use the ```install.packages()``` function in R to install the package from source. There my be cases where packages cannot install properly because of missing or broken dependencies. In such cases, look up the package in the [Rstudio package manager](https://packagemanager.rstudio.com/client/#/repos/1/packages/A3) and set the client OS to Ubuntu 20.04 to see if the desired package has dependencies that need to be installed for its use. If you would like to permanently include packages, then modify the [Dockerfile](https://github.com/aluro2/docker_visual_modeling/blob/master/Dockerfile) to include installation of the desired packages and their dependencies to the **visual_modeling_rstudio** Docker image.

#### Helpful docs and tutorials
- [Docker environments for RStudio](https://environments.rstudio.com/docker) 
- [R Docker Tutorial](http://ropenscilabs.github.io/r-docker-tutorial/)
- [pavo package R (note that we use version 2.4, so may not be up to date)](http://pavo.colrverse.com/articles/pavo-1-overview.html)



