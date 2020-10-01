
# Load packages -----------------------------------------------------------

library(tidyverse)
library(pavo)


# Import data -------------------------------------------------------------
specs <-
  readRDS(system.file("extdata/specsdata.rds", package = "pavo"))


# Read spectra names, find unique species measured ------------------------

# List all spectra names
names(specs)

# Get unique species IDs

# Get names of reflectance spectra, dropping column 1 (wavelength, "wl")
spec_names <-
  names(specs)[2:length(names(specs))]

strsplit(spec_names,"[.]")[1]

# Plot oriole reflectance spectra -----------------------------------------

oriole <-
  subset(specs, "oriole")

plot(
  oriole,
  col = spec2rgb(oriole)
)
