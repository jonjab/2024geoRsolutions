# episode 11
# dealing with CRSs

rm(list=ls())
current_episode <- 11


library(sf)
library(terra)
library(ggplot2)
library(dplyr)

aoi_boundary_HARV <- st_read(
  "data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp")

CHM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
CHM_HARV_df <- as.data.frame(CHM_HARV, xy=TRUE)

# this episode also needs the plot_locations_sp_HARV
# that was created in ep.10:
# Plot Locations
plot_locations_sp_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/PlotLocations_HARV.shp")


# Crop a Raster Using Vector Extent
# setup diagram:
ggplot() +
  geom_raster(data = CHM_HARV_df, aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  coord_sf()


# Crop a Raster Using Vector Extent
# make it so:
CHM_HARV_Cropped <- crop(x = CHM_HARV, y = aoi_boundary_HARV)

CHM_HARV_Cropped_df <- as.data.frame(CHM_HARV_Cropped, xy = TRUE)

ggplot() +
  geom_sf(data = st_as_sfc(st_bbox(CHM_HARV)), fill = "green",
          color = "green", alpha = .2) +
  geom_raster(data = CHM_HARV_Cropped_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_sf()

ggplot() +
  geom_raster(data = CHM_HARV_Cropped_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_sf()

# We can look at the extent of all of our other objects for this field site.
st_bbox(CHM_HARV)
st_bbox(CHM_HARV_Cropped)
st_bbox(aoi_boundary_HARV)

# ###########
# Challenge: Crop to Vector Points Extent
#
# Crop the Canopy Height Model to the extent of the study plot locations.
# Plot the vegetation plot location points on top of the Canopy Height Model.

CHM_plots_HARVcrop <- st_read("data/NEON-DS-Site-Layout-Files/HARV/PlotLocations_HARV.shp")

aoi <- st_bbox(CHM_plots_HARVcrop)
CHM_HARV_Cropped_2_Plots <- crop(CHM_HARV, aoi)
plot(CHM_HARV_Cropped_2_Plots)

CHM_plots_HARVcrop_df <- as.data.frame(CHM_HARV_Cropped_2_Plots, xy=TRUE)
str(CHM_plots_HARVcrop_df)


# plots and heights

ggplot() +
  geom_raster(data = CHM_plots_HARVcrop_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = plot_locations_sp_HARV) +
  coord_sf()




ggplot() +
  geom_raster(data = CHM_plots_HARVcrop_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  geom_sf(data = CHM_HARV_Cropped_2_Plots, color = "blue", fill = NA) +
  scale_fill_gradientn(name = "Canopy Height") +
  coord_sf()


ggplot() +
  geom_raster(data = CHM_HARV_Cropped_2_Plots_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = PlotLocations, color = "blue", fill = NA) +
  coord_sf()

# 1 lonely dot lives outside the extent. 
new_extent <- ext(732161.2, 732238.7, 4713249, 4713333)
CHM_HARV_manual_crop <- crop(CHM_HARV, new_extent)

CHM_HARV_manual_crop_df <- as.data.frame(CHM_HARV_manual_crop, xy=TRUE)


ggplot() +
  geom_raster(data = CHM_HARV_manual_crop_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = PlotLocations, color = "blue", fill = NA) +
  coord_sf()

ggplot() +
  geom_raster(data = CHM_HARV_manual_crop_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  coord_sf()


# Extract Data using x,y Locations
# make a buffer around a point

# point from episode 6:
point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")

# average tree height near our tower
str(point_HARV)
mean_tree_height_tower <- extract(x = CHM_HARV,
                                  y = point_HARV,
                                  raw=FALSE)

  
  mean_tree_height_tower <- extract(x = CHM_HARV,
                                  y = st_buffer(point_HARV, dist = 20),
                                  fun = mean)
str(mean_tree_height_tower)
mean_tree_height_tower

# challenge:
# do it for all the plot location points.
# is this the first time we use this data?
# points were created in ep. 10 OR can be found:
plot_locations_sp_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/PlotLocations_HARV.shp")
