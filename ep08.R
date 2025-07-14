# episode 8


rm(list=ls())
current_episode <- 8

library(sf)
library(terra)
library(ggplot2)

# 1 shapefile from episode 6:
aoi_boundary_HARV <- st_read(
  "data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp")

# 2 shapefiles from episode 7:
point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")
lines_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARV_roads.shp")

road_colors <-c("blue", "green", "navy", "purple")

ggplot() +
  geom_sf(data = aoi_boundary_HARV, fill = "grey", color = "darkgrey") +
  geom_sf(data = lines_HARV, aes(color = TYPE), size = 1) +
  scale_fill_manual(road_colors) +
  geom_sf(data = point_HARV) +
  ggtitle("NEON Harvard Forest Field Site") +
  coord_sf()

ggplot() +
  geom_sf(data = aoi_boundary_HARV, fill = "gray", color="black") +
  geom_sf(data = point_HARV, aes(fill=Sub_Type)) +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend="line", size = 1) +
  scale_color_manual(values=road_colors, name="Line Type") + 
  scale_fill_manual(values="black", name = "Tower Location")
    coord_sf()
  
    
HARV_CHM <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
HARV_CHM_df <- as.data.frame(HARV_CHM, xy=TRUE)
str(HARV_CHM_df)

# challenge 
ggplot() +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  geom_sf(data = aoi_boundary_HARV, fill = "gray", color="black") +
  geom_sf(data = point_HARV, color="black") +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend="line", size = 1) +
  scale_color_manual(values=road_colors, name="Line Type") + 
coord_sf()

