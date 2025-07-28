# ep 3 CRSs

library(pacman)
pacman::p_unload(pacman::p_loaded(), character.only = TRUE)


library(terra)
library(ggplot2)
library(dplyr)

rm(list=ls())


current_episode <- 3

DSM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
DSM_HARV_df <- as.data.frame(DSM_HARV, xy=TRUE)

DSM_hill_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")
DSM_hill_HARV_df <- as.data.frame(DSM_hill_HARV, xy=TRUE)

DTM_HARV <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")

DTM_hill_HARV <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_DTMhill_WGS84.tif")

DTM_HARV_df <- as.data.frame(DTM_HARV, xy = TRUE)
DTM_hill_HARV_df <- as.data.frame(DTM_hill_HARV, xy = TRUE)



ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = DTM_hill_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# individually they work
ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop))+ 
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
    coord_quickmap()

ggplot() + 
  geom_raster(data = DTM_hill_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  coord_quickmap()


crs(DTM_HARV, proj=TRUE) 
crs(DTM_hill_HARV, proj=TRUE)

crs(DTM_HARV) == crs(DTM_hill_HARV)

DTM_hill_utm18n <- DTM_hill_HARV %>% 
  project(crs(DTM_HARV))

crs(DTM_HARV) == crs(DTM_hill_utm18n)

# now we need to turn that into a dataframe again
DTM_hill_utm18n_df <- as.data.frame(DTM_hill_utm18n, xy=TRUE)

ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = DTM_hill_utm18n_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

ext(DTM_HARV)
ext(DTM_hill_utm18n)

res(DTM_HARV)
res(DTM_hill_utm18n)
res(DTM_hill_HARV)



# you could add resolution changes 
DTM_hill_utm18n <- DTM_hill_HARV %>% 
  project(crs(DTM_HARV), res=res(DTM_HARV))

# there's not an example spelled out where overlaying these 
# doesn't work before the resolution change

res(DTM_HARV)
res(DTM_hill_utm18n)



# challenge: San Joaquin DSM
DSM_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")
DSM_SJER_df <- as.data.frame(DSM_SJER, xy=TRUE)
DSM_hill_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill_WGS84.tif")
DSM_hill_SJER_df <- as.data.frame(DSM_hill_SJER, xy=TRUE)

res(DSM_SJER) == res(DSM_hill_SJER)
# also false


str(DSM_SJER_df)
str(DSM_hill_SJER_df)

# this won't work:
ggplot() +
  geom_raster(data = DSM_SJER_df , 
              aes(x = x, y = y, 
                  fill = SJER_dsmCrop)) + 
  geom_raster(data = DSM_hill_SJER_df, 
              aes(x = x, y = y, 
                  alpha = SJER_DSMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()


# this makes resolution match just by projecting. 
DSM_hill_SJER <- project(DSM_hill_SJER, DSM_SJER)
DSM_hill_SJER_df <- as.data.frame(DSM_hill_SJER, xy=TRUE)

res(DSM_hill_SJER) == res(DSM_SJER)

ggplot() +
  geom_raster(data = DSM_SJER_df , 
              aes(x = x, y = y, 
                  fill = SJER_dsmCrop)) + 
  geom_raster(data = DSM_hill_SJER_df, 
              aes(x = x, y = y, 
                  alpha = SJER_DSMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()


ggplot() +
  geom_raster(data = DSM_SJER_df , 
              aes(x = x, y = y, 
                  fill = SJER_dsmCrop)) + 
  geom_raster(data = DSM_hill_SJER_df, 
              aes(x = x, y = y, 
                  alpha = SJER_DSMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()
