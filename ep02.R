# ep 2 of vector / raster geospatial R

# setting up our libraries and objects 
# from scratch is a very good idea.

library(pacman)
pacman::p_unload(pacman::p_loaded(), character.only = TRUE)


library(terra)
library(ggplot2)
library(dplyr)


# these 2 lines are for good hygiene
current_episode <- 2

# who can tell me how to do this with pipe? %>% 
 rm(list=ls())


DSM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
DSM_HARV_df <- as.data.frame(DSM_HARV, xy=TRUE)

summary(DSM_HARV)
values(DSM_HARV) %>% summary()

summary(DSM_HARV_df)

# let's break the values into 3 chunks:
DSM_HARV_df <- DSM_HARV_df %>% 
  mutate(fct_elevation = cut(HARV_dsmCrop, breaks=3))

str(DSM_HARV_df)

ggplot() + 
  geom_bar(data=DSM_HARV_df, aes(x=fct_elevation))

unique(DSM_HARV_df$fct_elevation)

# let's round off our chunks
custom_bins <- c(300, 350, 400, 450)

DSM_HARV_df <- DSM_HARV_df %>% 
  mutate(fct_elevation2 = cut(HARV_dsmCrop, breaks=custom_bins))

str(DSM_HARV_df)

ggplot() + 
  geom_bar(data=DSM_HARV_df, aes(x=fct_elevation2))

# here's the old continuous one:
ggplot() +
  geom_raster(data=DSM_HARV_df, aes(x=x, y=y, fill = HARV_dsmCrop)) +
  coord_quickmap() +
  scale_fill_continuous()

# here's with breaks:
ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation2)) + 
  coord_quickmap() +
  scale_fill_manual(values = terrain.colors(3))

# let's control the name of our legend:
ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation2)) + 
  coord_quickmap() +
  scale_fill_manual(values = terrain.colors(3), name = "Elevation")

# let's name our color scheme:
my_colors <- terrain.colors(3)

my_colors

# let's turn off the axis labels:
ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                       fill = fct_elevation2)) + 
  scale_fill_manual(values = my_colors, name = "Elevation") +
  theme(axis.title = element_blank()) + 
  coord_quickmap()

# Challenge: Plot Using Custom Breaks
# Create a plot of the Harvard Forest Digital Surface Model (DSM) that has:

#  * Six classified ranges of values (break points) 
#    that are evenly divided among the range of pixel values.
#  * Axis labels.
#  * A plot title.

DSM_HARV_df <- DSM_HARV_df %>% 
  mutate(fct_elevation6 = cut(HARV_dsmCrop, breaks=6))

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                       fill = fct_elevation6)) + 
  scale_fill_manual(values = terrain.colors(6), name = "Elevation in 6 bins") +
  ggtitle("My 6 bin map") + 
  coord_quickmap()




# Layering Rasters

# now let's load a hillshade file.
# this will make a nice visualization
DSM_hill_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")
DSM_hill_HARV_df <- as.data.frame(DSM_hill_HARV, xy=TRUE)

describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")

ggplot() +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, fill = HARV_DSMhill)) + 
  coord_quickmap() 
  
# make that transparent
ggplot() +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.15, 0.65), guide = "none")

# you can play with those values:
ggplot() +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.05, 0.95), guide = "none")



# now add the classified layer back in:
ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation)) + 
  scale_fill_manual(values = terrain.colors(3)) +
  geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.15, 0.65), guide = "none")


# or the other column with the continuous values,
# and give it a name:
ggplot() +
  geom_raster(data = DSM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dsmCrop)) + 
  geom_raster(data = DSM_hill_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DSMhill)) +  
  scale_fill_viridis_c() +  
  scale_alpha(range = c(0.15, 0.65), guide = "none") +  
  ggtitle("Elevation with hillshade") +
  coord_quickmap()


# Now do that all over again with the SJER data:

# Use the files in the data/NEON-DS-Airborne-Remote-Sensing/SJER/ 
# directory to create a Digital Terrain Model map and Digital Surface Model 
# map of the San Joaquin Experimental Range field site.

# Make sure to:
#
#   * include hillshade in the maps,
#   * label axes on the DSM map and exclude them from the DTM map,
#   * include a title for each map,
#   * experiment with various alpha values and color palettes to represent the data.

DSM_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")
DSM_SJER_df <- as.data.frame(DSM_SJER, xy=TRUE)

DSM_SJER_df <- DSM_SJER_df %>% 
  mutate(fct_elevation = cut(SJER_dsmCrop, breaks=3))

DSM_hill_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill.tif")
DSM_hill_SJER_df <- as.data.frame(DSM_hill_SJER, xy=TRUE)
str(DSM_hill_SJER_df)

# this didn't work.
ggplot() +
  geom_raster(data = DSM_SJER_df , aes(x = x, y = y, fill = fct_elevation)) + 
  scale_fill_manual(values = terrain.colors(3), name = "Elevation") +
  theme(axis.title.y = element_blank()) + 
  theme(axis.title.x = element_blank()) + 
  ggtitle("San Joaquin Experimental Range DSM") +
  geom_raster(data = DSM_hill_SJER_df , aes(x = x, y = y, alpha = SJER_dsmHill)) + 
  coord_quickmap() +
  scale_alpha(range = c(0.15, 0.65), guide = "none")
