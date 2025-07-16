# ep 5
# color

rm(list=ls())
current_episode <- 5

library(terra)
library(dplyr)

# library(ggplot2)
# we can leave ggplot out this time.



# the lesson leaves out how to check for the number of layers:
nlyr(rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif"))

# or tidily:
rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif") %>% 
  nlyr()

# we will start with plotting 1 band
# of a 3-band raster:
RGB_band1_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", lyr=1)
# base plot is faster that doing the ggplots:
plot(RGB_band1_HARV)


# but it mucks up the graphics window
dev.off()


# Challenge
# discuss: is this gratuitous? have
# we had enough of summary() and standard-out?
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")




# Import A Specific Band
RGB_band2_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", lyr=2)
plot(RGB_band2_HARV)
summary(RGB_band1_HARV)

# Challenge: Making Sense of Single Band Images
# the lesson wants us to compare these visually.
# it is pretty subtle. is this one gratuitous?


# Raster Stacks in R
# ##########
# if we don't specify the layer, rast()
# loads all of them into a stack:
RGB_stack_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")
str(RGB_stack_HARV)
nlyr(RGB_stack_HARV)


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

plotRGB(RGB_stack_HARV, r=3, g=2, b=1)




# we may want it to look better:
plotRGB(RGB_stack_HARV, r=1, g=2, b=3,
        stretch="lin")

# this one really highlight species difference
plotRGB(RGB_stack_HARV, r=1, g=2, b=3,
        stretch="hist")

# scale from the lesson is an argument,
# but we don't really know what it's doing.
methods(class=class(RGB_stack_HARV))

?scale


# Challenge: nodata values.
# Let’s explore what happens with NoData values when working 
# with RasterStack objects and using the plotRGB() function. 
# We will use the HARV_Ortho_wNA.tif GeoTIFF file in the 
#                          ^^^^^^^^^
# NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/ directory.
#
#
#  View the files attributes. Are there NoData values assigned for this file?

describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")

#  If so, what is the NoData Value?

#  How many bands does it have?
HARV_NA <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")
nlyr(HARV_NA)

#  Load the multi-band raster file into R.

#  Plot the object as a true color image.
plotRGB(HARV_NA, r=1, g=2, b=3)

#  What happened to the black edges in the data?

#  What does this tell us about the difference in the data structure 
#  between HARV_Ortho_wNA.tif and HARV_RGB_Ortho.tif (R object RGB_stack). 
HARV_NA
RGB_stack_HARV

#  How can you check?
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")
describe(RGB_stack_HARV)

# SpatRaster in R
str(RGB_stack_HARV)
RGB_stack_HARV

# spatraster dataset
# for most purposes: these are the same.
RGB_sds_HARV <- sds(RGB_stack_HARV)

str(RGB_sds_HARV)

# but there can be multiple rasters:
RGB_sds_HARV <- sds(list(RGB_stack_HARV, RGB_stack_HARV))

# what can you send to these?
# compare the lists:

?rast
?sds

# like an Esri RasterCatalog???

# you can call each raster individually
# for the teachers: are stacks what we use for the small
# multiple NDVIs?
RGB_sds_HARV[[1]]
RGB_sds_HARV[[2]]

# Challenge: ############
#   What Functions Can Be Used on an R Object of a particular class?
#  We can view various functions (or methods) available to use on an R object with methods(class=class(objectNameHere)). Use this to figure out:
#  
#  What methods can be used on the RGB_stack_HARV object?
#  What methods can be used on a single band within RGB_stack_HARV?

methods(class=class(RGB_sds_HARV))
methods(class=class(RGB_stack_HARV))









#  Why do you think there isn’t a difference?