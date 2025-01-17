# geospatial R episode 3
# Projections and CRS's
# Overlaying raster and hillshade

rm(list=ls())

library(terra)
library(dplyr)
library(ggplot2)

DTM_HARV <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")

DTM_hill_HARV <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_DTMhill_WGS84.tif")

DTM_HARV_df <- as.data.frame(DTM_HARV, xy=TRUE)
DTM_hill_HARV_df <- as.data.frame(DTM_hill_HARV, xy=TRUE)


# intentional gotcha: the original rasters
# have 2 different CRSs

ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = DTM_hill_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()


# both work fine on their own
ggplot() +
  geom_raster(data = DTM_HARV_df,
              aes(x = x, y = y,
                  fill = HARV_dtmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

ggplot() +
  geom_raster(data = DTM_hill_HARV_df,
              aes(x = x, y = y,
                  alpha = HARV_DTMhill_WGS84)) + 
  coord_quickmap()

# what's up? That's visible on the axis labels: those are
# 2 very different systems.

# ###########################
# Exercise: view the CRSs
crs(DTM_HARV) # epsg is a unique identifier

## r pro tip: parse = TRUE
crs(DTM_HARV, parse=TRUE) # UTM 18N
crs(DTM_hill_HARV, parse=TRUE) # unprojected geocoordinates in decimal degrees


# reproject your data with project(x, the_crs_you_want)
# remember: the crs is an objecttype of its own
DTM_hill_UTMZ18N_HARV <- project(DTM_hill_HARV, crs(DTM_HARV))

# now they should be the same
crs(DTM_HARV, parse=TRUE) 
crs(DTM_hill_UTMZ18N_HARV, parse=TRUE)

# you can always check without having to read:
(crs(DTM_HARV) == crs(DTM_hill_UTMZ18N_HARV))

# so do they overlay now?
# back to the intentional gotcha: 
DTM_hill_UTMZ18N_HARV_df <- as.data.frame(DTM_hill_UTMZ18N_HARV, xy=TRUE)
ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = DTM_hill_UTMZ18N_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# they do. So I'm not sure why we really need to deal 
# with the extents and resolutions, but ... 


# extents work the same way
# challenge: why are extents different?
ext(DTM_hill_UTMZ18N_HARV)
ext(DTM_hill_HARV)
ext(DTM_HARV)  

# resolution can be forced
# to be identical also using project()
res(DTM_hill_UTMZ18N_HARV)
res(DTM_hill_HARV)
res(DTM_HARV)  

DTM_hill_UTMZ18N_HARV <- project(DTM_hill_HARV, 
                                 crs(DTM_HARV), 
                                 res = res(DTM_HARV)) 

ext(DTM_HARV)  
ext(DTM_hill_UTMZ18N_HARV)

res(DTM_HARV)  
res(DTM_hill_UTMZ18N_HARV)

# a new dataframe for plotting again:
DTM_hill_UTMZ18N_HARV_2_df <- as.data.frame(DTM_hill_UTMZ18N_HARV, xy=TRUE)
ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = DTM_hill_UTMZ18N_HARV_2_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# So do the extents and resolutions
# really need to match? Or just the CRS?


##################
# Final challenge

# Our of Jon's head:
SJER_DSMhill_WGS84 <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill_WGS84.tif")
SJER_dsmCrop <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")

crs(SJER_DSMhill_WGS84) == crs(SJER_dsmCrop)

SJER_dsmCrop_projected <- project(SJER_dsmCrop, crs(SJER_DSMhill_WGS84))

crs(SJER_DSMhill_WGS84) == crs(SJER_dsmCrop_projected)


SJER_dsmCrop_projected_df <- as.data.frame(SJER_dsmCrop_projected, xy=TRUE)
SJER_DSMhill_WGS84_df <- as.data.frame(SJER_DSMhill_WGS84, xy=TRUE)

str(SJER_dsmCrop_projected_df)
str(SJER_DSMhill_WGS84_df)

ggplot() +
  geom_raster(data = SJER_dsmCrop_projected_df, 
              aes(x = x, y = y, 
                  fill = SJER_dsmCrop)) + 
  geom_raster(data = SJER_DSMhill_WGS84_df, 
              aes(x = x, y = y, 
                  alpha = SJER_DSMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  ggtitle("Jon's DSM with Hillshade, WGS") +
  coord_quickmap()
# this makes a really pretty picture of the
# tops of trees and shrubs -- that's the main
# diff between DTM and DSM
# also, Jon's version comes out square in WGS


# here's the solution from the lesson, that comes out as
# a rectangle in UTM
##########################################################

rm(list=ls())

# import DSM
DSM_SJER <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")
# import DSM hillshade
DSM_hill_SJER_WGS <-
  rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill_WGS84.tif")

# reproject raster
# note: in Jon's version, the resolution step is skipped
DSM_hill_UTMZ18N_SJER <- project(DSM_hill_SJER_WGS,
                                 crs(DSM_SJER),
                                 res = 1)

# convert to data.frames
DSM_SJER_df <- as.data.frame(DSM_SJER, xy = TRUE)

DSM_hill_SJER_df <- as.data.frame(DSM_hill_UTMZ18N_SJER, xy = TRUE)

ggplot() +
  geom_raster(data = DSM_hill_SJER_df, 
              aes(x = x, y = y, 
                  alpha = SJER_DSMhill_WGS84)
  ) +
  geom_raster(data = DSM_SJER_df, 
              aes(x = x, y = y, 
                  fill = SJER_dsmCrop,
                  alpha=0.8)
  ) + 
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  ggtitle("Canonical DSM with Hillshade, alpha=.4, WGS") + 
  coord_quickmap()


# 2nd 1/2 of challenge:
# it doesn't quite match lesson 2, because i was futzing around
# with the alphas.


