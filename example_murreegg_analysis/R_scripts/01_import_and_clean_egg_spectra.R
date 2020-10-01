
# Load packages and import data -------------------------------------------
library(tidyverse)
library(pavo)

## get egg reflectance spectra, smooth lines and add correction to negative values
iceland_murre_egg_spectra <-
  # import raw reflectance data from "data/" directory
  as.rspec(
    read_csv("data/iceland_murre_eggs_spectra.csv")
  ) %>%
  # process the reflectance spectra
  procspec(
    # smooth reflectance spectra data by a span of 0.25
    opt = "smooth",
    span = 0.25,
    # replace any negative reflectance values with 0
    fixneg = "zero"
  )


# Save smoothed and cleaned reflectance data ------------------------------

write_csv(
  iceland_murre_egg_spectra,
  "data/iceland_murre_eggs_spectra_cleaned.csv"
)
