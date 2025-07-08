# ep 2 of vector / raster geospatial R

# these 2 lines are for good hygiene
rm(list=ls())
current_episode <- 1

# setting up our libraries and object 
# from scratch is a very good idea.

library(terra)
library(ggplot2)
library(dplyr)

DSM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
DSM_HARV_df <- as.data.frame(DSM_HARV, xy=TRUE)

summary(DSM_HARV)
summary(DSM_HARV_df)

DSM_HARV_df <- DSM_HARV_df %>% 
  mutate(fct_elevation = cut(HARV_dsmCrop, breaks=3))

str(DSM_HARV_df)

ggplot() + 
  geom_bar(data=DSM_HARV_df, aes(x=fct_elevation))

custom_bins <- c(300, 350, 400, 450)

DSM_HARV_df <- DSM_HARV_df %>% 
  mutate(fct_elevation2 = cut(HARV_dsmCrop, breaks=custom_bins))

str(DSM_HARV_df)
ggplot() +
  geom_raster(data=DSM_HARV_df, aes(x=x, y=y, fill = HARV_dsmCrop)) +
  coord_quickmap() +
  scale_fill_continuous()


ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation2)) + 
  coord_quickmap() +
  scale_fill_manual(values = terrain.colors(3))

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation2)) + 
  coord_quickmap() +
  scale_fill_manual(values = terrain.colors(3), name = "Elevation")

DSM_hill_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")
DSM_hill_HARV_df <- as.data.frame(DSM_hill_HARV, xy=TRUE)
str("data/")

describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")

ggplot() +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, fill = HARV_DSMhill)) + 
  coord_quickmap() 
  
ggplot() +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.15, 0.65), guide = "none")

ggplot() +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.05, 0.95), guide = "none")


ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation2)) + 
  scale_fill_manual(values = terrain.colors(3), name = "Elevation") +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.15, 0.65), guide = "none")

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = HARV_dsmCrop)) + 
  scale_fill_viridis_c()  +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.15, 0.65), guide = "none")


# challenge: use the binned values
ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation)) + 
  scale_fill_manual(values = terrain.colors(3)) +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.15, 0.65), guide = "none")

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation2)) + 
  scale_fill_manual(values = terrain.colors(3)) +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.15, 0.65), guide = "none")

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation2)) + 
  scale_fill_viridis_d() +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.15, 0.65), guide = "none")
