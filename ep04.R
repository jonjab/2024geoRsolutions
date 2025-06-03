# ep 4
# raster math

rm(list=ls())
current_episode <- 4

library(terra)
library(ggplot2)
library(dplyr)

DTM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
DSM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

summary(DTM_HARV)

CHM_HARV <- DSM_HARV - DTM_HARV
plot(CHM_HARV)
summary(CHM_HARV)                 
CHM_HARV

CHM_HARV_df <- as.data.frame(CHM_HARV, xy=TRUE)
# plot(CHM_HARV_df)


ggplot(CHM_HARV_df) +
  geom_histogram(aes(HARV_dsmCrop))

# challenge ###############
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
