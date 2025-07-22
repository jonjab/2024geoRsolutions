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

# running this line-by-line helps explain how things get layered
# together
# and the point doesn't show up until the coord_sf comes in
ggplot() +
  geom_sf(data = aoi_boundary_HARV, fill = "grey", color = "darkgrey") +
  geom_sf(data = lines_HARV, aes(color = TYPE), linewidth = 1) +
  scale_color_manual(values = road_colors) +
  geom_sf(data = point_HARV) +
  ggtitle("NEON Harvard Forest Field Site") +
  coord_sf()

ggplot() +
  geom_sf(data = aoi_boundary_HARV, fill = "gray", color="black") +
  geom_sf(data = point_HARV, aes(fill=Sub_Type), 
          shape="15",
          color="red") +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend="line", linewidth = .5) +
  scale_color_manual(values=road_colors, name="Line Type") + 
  scale_fill_manual(values="black", name = "Tower Location") +
  coord_sf()
  

## STOPPED HERE

HARV_CHM <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
HARV_CHM_df <- as.data.frame(HARV_CHM, xy=TRUE)
str(HARV_CHM_df)

# challenge 
# plot soils by type
plot_locations <- st_read("data/NEON-DS-Site-Layout-Files/HARV/PlotLocations_HARV.shp")

plot(soilTypeOr)
str(soilTypeOr)
unique((soilTypeOr$soilTypeOr))

soil_colors <- c("brown", "green")

ggplot() +
  geom_sf(data = plot_locations, aes(color=soilTypeOr)) +
  scale_color_manual(values=soil_colors) +
  geom_sf(data = lines_HARV) +
  coord_sf()

ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend = "line", size = 1) +
  geom_sf(data = plot_locations, aes(fill = soilTypeOr, shape = soilTypeOr),
          show.legend = 'point', size = 3) +
  scale_shape_manual(name = "Soil Type", values = c(21, 22)) +
  scale_color_manual(name = "Line Type", values = road_colors,
                     guide = guide_legend(override.aes = list(linetype = "solid", shape = NA))) +
  scale_fill_manual(name = "Soil Type", values = soil_colors,
                    guide = guide_legend(override.aes = list(linetype = "blank", shape = c(21, 22), color = "black"))) +
  ggtitle("NEON Harvard Forest Field Site") +
  coord_sf()


# challenge 2
CHM_HARV_df <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif") %>% 
  as.data.frame(xy=TRUE)

ggplot() +
  geom_raster(data = CHM_HARV_df, aes(x = x, y = y, fill = HARV_chmCrop)) +
  geom_sf(data = lines_HARV, color = "black") +
  geom_sf(data = aoi_boundary_HARV, color = "grey20", size = 1) +
  geom_sf(data = point_HARV, pch = 8) +
  ggtitle("NEON Harvard Forest Field Site w/ Canopy Height Model") +
  coord_sf()


