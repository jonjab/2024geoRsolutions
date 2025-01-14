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


# extents work the same way
# and it's best if they match?
# challenge: why are extents different?
ext(DTM_hill_UTMZ18N_HARV)
ext(DTM_hill_HARV)
ext(DTM_HARV)  

# resolution can be forced
# to be identical also
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

