# ep 4
# raster math and CHM

rm(list=ls())

library(terra)
library(ggplot2)
library(dplyr)

describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")


DTM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
DSM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

crs(DTM_HARV) == crs(DSM_HARV)

CHM_HARV <- DSM_HARV - DTM_HARV
summary(CHM_HARV)

CHM_HARV_df <- as.data.frame(CHM_HARV, xy=TRUE)
str(CHM_HARV_df)

ggplot () +
  geom_raster(data=CHM_HARV_df,
              aes(x=x, y=y, fill = HARV_dsmCrop))


  ggplot() +
  geom_histogram(data = CHM_HARV_df, aes(HARV_dsmCrop), bins = 40)

