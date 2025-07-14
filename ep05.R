# ep 5
# color

rm(list=ls())
current_episode <- 5

library(terra)
library(ggplot2)
library(dplyr)


# the lesson leaves out how to check for the number of layers:
nlyr(rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif"))

# or tidily:
rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif") %>% 
  nlyr()

# we will start with plotting 1 band:
RGB_band1_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", lyr=1)
# base plot is faster:
plot(RGB_band1_HARV)



# Challenge
# discuss: is this gratuitous? have
# we had enough of summary()?


# Import A Specific Band
RGB_band2_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", lyr=2)
plot(RGB_band2_HARV)

# Challenge: Making Sense of Single Band Images
# the lesson wants us to compare these visually.
# it is pretty subtle. is this one gratuitous?


# Raster Stacks in R
# ##########
# if we don't specify the layer, rast()
# loads all of them into a stack:
RGB_stack_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

# the lesson buries the lead. let's plot it:
plot(RGB_stack_HARV)
plotRGB(RGB_stack_HARV, r=1, g=2, b=3)

# now let's look at attributes:
RGB_stack_HARV

# or attributes of individual layers:
RGB_stack_HARV[[2]]

# the lesson wants to make ggplots
# of individual bands. that also feels gratuitous.
# so......

# Create A Three Band Image
plotRGB(RGB_stack_HARV, r=1, g=2, b=3)

# we may want it to look better:
plotRGB(RGB_stack_HARV, r=1, g=2, b=3,
        stretch="lin")

# this one really highlight species difference
plotRGB(RGB_stack_HARV, r=1, g=2, b=3,
        stretch="hist")

# scale from the lesson is an argument,
# but we don't really know what it's doing.
methods(class=class(RGB_stack_HARV))

# Challenge: nodata values.
# Let’s explore what happens with NoData values when working 
# with RasterStack objects and using the plotRGB() function. 
# We will use the HARV_Ortho_wNA.tif GeoTIFF file in the 
#                          ^^^^^^^^^
# NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/ directory.
#
#
#  View the files attributes. Are there NoData values assigned for this file?

#  If so, what is the NoData Value?

#  How many bands does it have?

#  Load the multi-band raster file into R.

#  Plot the object as a true color image.

#  What happened to the black edges in the data?

#  What does this tell us about the difference in the data structure 
#  between HARV_Ortho_wNA.tif and HARV_RGB_Ortho.tif (R object RGB_stack). 

#  How can you check?
