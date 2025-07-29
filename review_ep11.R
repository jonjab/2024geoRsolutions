# Review: 
#   --buffers
#   --project organization

# let's eject all of our packages.
library(pacman)
pacman::p_unload(pacman::p_loaded(), character.only = TRUE)
p_loaded()

rm(list=ls())
current_episode <- 11

library(sf)
library(ggplot2)
library(dplyr)
library(terra)


# the heights of all of our trees 
# CHM = treetops elevation - ground elevation
# made this in episode 4
CHM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
CHM_HARV_df <- as.data.frame(CHM_HARV, xy=TRUE)

# the plot_locations_sp_HARV
# was created in ep.10 from a csv:
# ps: this is the version that was given to us by carpentry
# Plot Locations
plot_locations_sp_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/PlotLocations_HARV.shp")

# extract doesn't make a new dataframe. 


# Let's figure out the 
# average tree height near our tower
# location of the tower. a single point shapefile from episode 6:
point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")
str(point_HARV)

# A good teaching moment
# If you loaded tidyr, this will raise an error as extract()
# from tidyr will conflict with the one from terra. 
# don't forget how to specify which libraries get used: terra:extract()
# Jon' didn't get that error. is that because tidyr isn't loaded?

# if this throws an error:
mean_tree_height_tower <- extract(x = CHM_HARV,
                                   y = st_buffer(point_HARV, dist = 20),
                                   fun = mean)
# this will not:
mean_tree_height_tower <- terra::extract(x = CHM_HARV,
                                  y = st_buffer(point_HARV, dist = 20),
                                  fun = mean)

str(mean_tree_height_tower)
mean_tree_height_tower


# Graph the average tree heights
# for the 20 meters around each 
# plot location (plot_locations_sp_HARV)

# extract data at each plot location
mean_tree_height_plots_HARV <- terra::extract(x = CHM_HARV,
                                       y = st_buffer(plot_locations_sp_HARV,
                                                     dist = 20),
                                       fun = mean)

# view data
mean_tree_height_plots_HARV


# now plot the average heights:
ggplot(data = mean_tree_height_plots_HARV, aes(x=ID, y=HARV_chmCrop)) +
  geom_col() +
  ggtitle("Mean Tree Height at each Plot") +
  xlab("Plot ID") +
  ylab("Tree Height (m)")

# sort it tallest to lowest plots:
ggplot(data = mean_tree_height_plots_HARV, aes(reorder(ID, -HARV_chmCrop), HARV_chmCrop)) +
  geom_col() +
  ggtitle("Plots by mean tree height") +
  xlab("Plot ID") +
  ylab("Tree Height (m)")
