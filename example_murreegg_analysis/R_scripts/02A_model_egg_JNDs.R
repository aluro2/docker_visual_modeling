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

# Get egg background color spectra only
egg_bkg_spectra <-
  subset(x = iceland_murre_egg_spectra, subset = "background")


# Run visual model, get JND values ---------------------------------------------------------

egg_background_JNDs <-
  # pipe ("%>%" ) reflectance spectra data "vismodel" quantum catch calculation function
  egg_bkg_spectra %>%
      # Get photoreceptor cone catch, assuming Murres have a violet-sensitive SWS1 cone: https://doi.org/10.1098/rsbl.2009.0877
      vismodel(
        # The period "." is a placeholder for the piped object ("egg_bkg_spectra")
        rspecdata = .,
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
      ) %>%
  # next, we pipe the calculated cone quantum catches into a "rename" column function to change VS cone name to "v" instead of "u"
      rename(
        .data = .,
        "v" = "u"
      ) %>%
  # finally, pipe the cone quantum catch values into RNL-modeling function "coldist"
      # get JND values from a receptor-noise limited model
      coldist(
        modeldata = .,
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

# Save the calculated JND values as .csv
write_csv(egg_background_JNDs, path = "data/egg_background_JNDs.csv")
# Also save as .rds--this preserves the format that pavo uses for jndxyz(). jndxyz will NOT work if egg_background_JNDs is changed in any way (i.e., the .csv file won't work)
saveRDS(egg_background_JNDs, file = "data/egg_background_JNDs.rds")


# 3D JND-XYZ plot ---------------------------------------------------------

# Get JND data
egg_background_JNDs <-
  read_rds(path = "data/egg_background_JNDs.rds") 

# pipe JND data into jnd2xyz function
egg_background_JNDXYZ <-
  egg_background_JNDs %>% 
      jnd2xyz(
        coldistres = .,
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
  
# Save the JND-XYZ values as .csv and .rds files
egg_background_JNDXYZ %>% 
    rownames_to_column(., "egg_ID")%>%
    # rename the JND xyz value column names
    rename("JND_X" = "x", "JND_Y" = "y", "JND_Z" = "z", "Luminance" = "lum") %>% 
  # output as a .csv file
  write_csv(., "data/egg_background_JNDXYZ.csv")

# Again, also save as .rds for other pavo functions to work
  saveRDS(egg_background_JNDXYZ, "data/egg_background_JNDXYZ.rds")
  

# 3D JND plot -------------------------------------------------------------

# import JND-XYZ data  
egg_background_JNDXYZ <-
    read_rds("data/egg_background_JNDXYZ.rds")

## Make a pdf save file in "figures/" directory named "jnd_xyz_plot_egg_background.pdf"
pdf("figures/jnd_xyz_plot_egg_background.pdf")

# make 3D JND-XYZ plot
JNDXYZ_plot<-
egg_background_JNDXYZ %>% 
    jndplot(
      x = .,
      arrow = "relative",
      arrow.p = 2,
      arrow.col = "blue",
      # color points using RGG colors derived from egg bkg reflectance spectra
      col = spec2rgb(egg_bkg_spectra),
      margin = c(1, 3, 1, 0),
      cex = 3,
      square = F,
      xlab = "JND-X",
      ylab = "JND-Y",
      zlab = "JND-Z"
    )

# Add a title and position it 2 lines down from top of page
    title(
      main = "Murre egg background color",
      line = -2
    )


# close the pdf file to save it
dev.off()

# double-check that the colored points of the 3D JND plot correspond with the reflectace spectra (for egg spotting)
plot(egg_bkg_spectra, col = spec2rgb(egg_bkg_spectra), lwd = 5)


