# Load packages and import data -------------------------------------------
library(tidyverse)
library(pavo)

# import cleaned murre egg reflectance data from "data/" directory
iceland_murre_egg_spectra <-
  as.rspec(
    read_csv(
      "data/iceland_murre_eggs_spectra_cleaned.csv"
    )
  )

# Split data by background color and spot color ---------------------------

# Separate spectra into list of length 2, one for egg "background" and one for egg spotting ("spot")
egg_spectra_split <-
  list(
    egg_background = subset(iceland_murre_egg_spectra, "background"),
    egg_spot = subset(iceland_murre_egg_spectra, "spot")
  )


# Run visual model, get JND values ---------------------------------------------------------

egg_JNDs_split <-
  # pipe reflectance spectra data list into list-apply ("lapply") function
  egg_spectra_split %>%
  lapply(
    .,
    function(x) {
      # Get photoreceptor cone catch, assuming Murres have a violet-sensitive SWS1 cone: https://doi.org/10.1098/rsbl.2009.0877
      vismodel(
        x,
        # peafowl VS-type visual system
        visual = "pfowl",
        # bright mid-day sunlight irradiance spectrum
        illum = "D65",
        # ideal (flat grey) background which [murre egg] objects are viewed against
        bkg = "ideal",
        # ideal ocular media transmission (100% transmission across all light wavelengths)
        trans = "ideal",
        # use chicken double-cone for achromatic perception
        achromatic = "ch.dc",
        # apply a Von-Kries correction (i.e., assume color constancy in response to environmental lighting)
        vonkries = T,
        # set cone catches to relative to one another for receptor-noise limited modeling 
        relative = F
      )
    }
  ) %>%
  # pipe the calculated cone quantum catches into a list-apply to change VS cone name to "v" instead of "u"
  lapply(
    .,
    function(x) {
      rename(
        x,
        "v" = "u"
      )
    }
    # pipe the cone quantum catch values into list-apply of RNL-modeling function "coldist"
  ) %>%
  lapply(
    .,
    function(x) {
      # get JND values from a receptor-noise limited model
      coldist(
        x,
        # assume "neural" noise affects photoreception
        noise = "neural",
        # include calculation of achromatic JNDs
        achro = T,
        # set photoreceptor density ratios to (default Pekin robin): VS=1, MWS=2, LWS=2, double-cone=4 
        n = c(1, 2, 2, 4),
        # set weber noise fraction to 0.1
        weber = 0.1,
        # use the LWS cone as the reference for the weber fraction
        weber.ref = "longest"
      )
    }
    # pipe calculated JND values into list-apply function to make a 3D JND plot
  ) %>%
  lapply(
    .,
    function(x) {
      jnd2xyz(
        x,
        rotate = T,
        # center the data onto the "mean" JND XYZ value
        center = T,
        rotcenter = "mean",
        # flip the axes by the LWS "l"and VS "v" cone coordinates
        ref1 = "l",
        ref2 = "v",
        # rotate the plot
        axis1 = c(1, 1, 0),
        axis2 = c(0, 0, 1)
      )
    }
  )

## show the first 3 lines of the `egg_JNDs_split` data, for each list item (background and spotting colors)
lapply(egg_JNDs_split, head, 3)


# 3D JND plot -------------------------------------------------------------

## Make a pdf save file in "figures/" directory named "jnd_xyz_plots.pdf"
pdf(
  "figures/jnd_xyz_plots.pdf"
)

# multiple list-apply ("mapply") the jndplot function to both list items
mapply(
  function(x, y, z) {
    jndplot(
      x,
      arrow = "relative",
      arrow.p = 2,
      arrow.col = "blue",
      col = spec2rgb(y),
      margin = c(1, 3, 1, 0),
      cex = 3,
      square = F,
      xlab = "JND-X",
      ylab = "JND-Y",
      zlab = "JND-Z"
    )

    title(
      main = z,
      line = -2
    )
  },
  # x = the list of JND dataframes (murre egg background and egg spotting JNDs)
  x = egg_JNDs_split,
  # y = the reflectance spectra data used to color the points in the 3D JND plot using "spec2rgb()"
  y = egg_spectra_split,
  # z = the titles for each 3D JND  plot 
  z = c("Murre egg backgrounds", "Murre egg spots")
)

# close the pdf file to save it
dev.off()

# double-check that the colored points of the 3D JND plot correspond with the reflectace spectra (for egg spotting)
plot(egg_spectra_split$egg_spot, col = spec2rgb(egg_spectra_split$egg_spot), lwd = 5)


# Save the JND-xyz values as a .csv file ----------------------------------

# Get egg sample RGB colors
egg_RGB_colors <-
  # list-apply to each dataset (egg background and egg spotting)
  lapply(
    egg_spectra_split,
    function(x) {
      # make a dataframe (as "tibble") with an "egg_ID" column of sample names and "egg_RGB_col" with RGB colors of samples
      tibble(egg_ID = names(spec2rgb(x)), egg_RGB_col = spec2rgb(x))
    }
    # pipe created dataframes into "bind_rows" to combine them into a single dataframe
  ) %>%
  bind_rows(.)

# Combine the JND-xyz values with the egg RGB colors, then save the data as a .csv file in the "data/" directory
egg_JNDs_split %>%
  # combine the JND-xyz values of egg background and egg spotting datasets
  bind_rows(.) %>%
  # make a sample identifier column, "egg_ID"
  rownames_to_column(., "egg_ID") %>%
  # rename the JND xyz value column names
  rename("JND_X" = "x", "JND_Y" = "y", "JND_Z" = "z", "Luminance" = "lum") %>%
  # combine JND xyz data with egg RGB color data 
  right_join(egg_RGB_colors, ., "egg_ID") %>%
  # separate the "egg_ID" at the underscore, create new "egg_ID" (sample name) and "egg_feature" (egg bkg or spotting) columns
  separate(
    col = egg_ID,
    into = c("egg_ID", "egg_feature"),
    sep = "_"
  ) %>%
  # save the data as "iceland_murre_eggs_jndxyz.csv" in the "data/" directory
  write_csv(
    .,
    "data/iceland_murre_eggs_jndxyz.csv"
  )
