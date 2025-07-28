# ep 4
# raster math

library(pacman)
pacman::p_unload(pacman::p_loaded(), character.only = TRUE)


rm(list=ls())
current_episode <- 4

library(terra)
library(ggplot2)
library(dplyr)

# the objects we will need:
# note: it is a 1 character difference!
DTM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
DSM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

describe(DTM_HARV)
describe(DSM_HARV)

summary(DTM_HARV)
summary(DSM_HARV)

crs(DTM_HARV) == crs(DSM_HARV)

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

summary(CHM_HARV_df)
# min = 0
# max = 38.18

#  2 What are two ways you can check this range of data for CHM_HARV?

# summary or stdout

#  3 What is the distribution of all the pixel values in the CHM?

# histograms show distributions.

#  4 Plot a histogram with 6 bins instead of the default 
#    and change the color of the histogram.

ggplot(CHM_HARV_df) +
  geom_histogram(aes(HARV_dsmCrop), bins = 6)

#  5 Plot the CHM_HARV raster using breaks that make sense for the data. 
#    Include an appropriate color palette for the data, plot title and no axes ticks / labels.

ggplot() +
  geom_raster(data = CHM_HARV_df, 
              aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(3)) + 
  ggtitle("What makes sense?") +
    coord_quickmap()

my_scale <- c(0, 2, 10, 35)    

# like this!
# DSM_HARV_df <- DSM_HARV_df %>% 
#   mutate(fct_elevation6 = cut(HARV_dsmCrop, breaks=6))

CHM_HARV_df <- CHM_HARV_df %>% 
  mutate(classes = cut(HARV_dsmCrop, breaks=my_scale))

str(CHM_HARV_df)
summary(CHM_HARV_df)

ggplot() +
  geom_raster(data = CHM_HARV_df, 
              aes(x = x, y = y, fill = classes)) +
  scale_fill_manual(values=terrain.colors(3)) +
  ggtitle("What makes sense? Does 3 make sense?") +
coord_quickmap()



# Efficient Raster Calculations
# lapp() never, ever comes up again. 
# skip for time?

# Export a geotiff
#
writeRaster(CHM_HARV, "CHM_HARV.tiff",
            filetype="GTIFF",
            overwrite=TRUE,
            NAflag=-9999)

# final challenge: do it all again in the desert.

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
