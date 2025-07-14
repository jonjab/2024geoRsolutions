# ep 4
# raster math

rm(list=ls())
current_episode <- 4

library(terra)
library(ggplot2)
library(dplyr)

# the objects we will need:
# note: it is a 1 character difference!
DTM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
DSM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

summary(DTM_HARV)

# make dataframes:
DSM_HARV_df <- as.data.frame(DSM_HARV, xy=TRUE)
DTM_HARV_df <- as.data.frame(DTM_HARV, xy=TRUE)

# test ggplots:
ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dtmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  ggtitle("DTM Elevation: bare earth") +
  coord_quickmap()

ggplot() +
  geom_raster(data = DSM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  ggtitle("DSM Elevation: treetops") +
  coord_quickmap()

# you may also want to plot without 
# the coord_quickmap in order to see the difference.


# ###################################
# Two Ways to Perform Raster Calculations

# the briefest:
CHM_HARV <- DSM_HARV - DTM_HARV

# what does a Canopy Height Model Show?
plot(CHM_HARV)

summary(CHM_HARV)                 
CHM_HARV

# do it tidystyle:
CHM_HARV_df <- as.data.frame(CHM_HARV, xy=TRUE)
str(CHM_HARV_df)

ggplot() +
  geom_raster(data = CHM_HARV_df, 
              aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  coord_quickmap()

ggplot(CHM_HARV_df) +
  geom_histogram(aes(HARV_dsmCrop))

# ###############
# Challenge: Explore CHM Raster Values

# exploratory data analysis
# 1 What is the min and maximum value for the Harvard Forest 
#   Canopy Height Model (CHM_HARV) that we just created?

#  2 What are two ways you can check this range of data for CHM_HARV?

#  3 What is the distribution of all the pixel values in the CHM?

#  4 Plot a histogram with 6 bins instead of the default 
#    and change the color of the histogram.

#  5 Plot the CHM_HARV raster using breaks that make sense for the data. 
#    Include an appropriate color palette for the data, plot title and no axes ticks / labels.






DTM_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmCrop.tif")
DSM_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")

CHM_SJER <- DSM_SJER - DTM_SJER

DTM_SJER_df <- as.data.frame(DTM_SJER , xy=TRUE)
DSM_SJER_df <- as.data.frame(DSM_SJER , xy=TRUE)

CHM_SJER_df <- as.data.frame(CHM_SJER , xy=TRUE)
plot(CHM_SJER)
str(CHM_SJER_df)
ggplot(CHM_SJER_df) +
  geom_histogram(aes(SJER_dsmCrop))
