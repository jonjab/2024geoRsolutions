# episode 9
# dealing with CRSs

rm(list=ls())
current_episode <- 9

library(sf)
library(terra)
library(ggplot2)
library(dplyr)

# Read US Boundary File
state_boundary_US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-State-Boundaries-Census-2014.shp") %>%
  st_zm()

ggplot() +
  geom_sf(data = state_boundary_US) +
  ggtitle("Map of Contiguous State Boundaries") +
  coord_sf()

# Read US Boundary Layer
# to 'punch out' an outline
country_boundary_US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-Boundary-Dissolved-States.shp") %>%
  st_zm()

ggplot() +
  geom_sf(data = state_boundary_US, color = "gray60") +
  geom_sf(data = country_boundary_US, color = "black",alpha = 0.25,size = 5) +
  ggtitle("Map of Contiguous US State Boundaries") +
  coord_sf()


point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")
st_crs(point_HARV)$proj4string

# CRS Units - View Object Extent
st_bbox(point_HARV)
st_bbox(state_boundary_US)

# Reproject Vector Data or No?
# we don't have to!
ggplot() +
  geom_sf(data = state_boundary_US, color = "gray60") +
  geom_sf(data = country_boundary_US, size = 5, alpha = 0.25, color = "black") +
  geom_sf(data = point_HARV, shape = 19, color = "purple") +
  ggtitle("Map of Contiguous US State Boundaries") +
  coord_sf()



# Challenge - Plot Multiple Layers of Spatial Data
NE.States.Boundary.US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/Boundary-US-State-NEast.shp") %>%
  st_zm()

ggplot() +
  geom_sf(data = NE.States.Boundary.US, aes(color ="color"),
          show.legend = "line") +
  scale_color_manual(name = "", labels = "State Boundary",
                     values = c("color" = "gray18")) +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  scale_shape_manual(name = "", labels = "Fisher Tower",
                     values = c("shape" = 19)) +
  ggtitle("Fisher Tower location") +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()

# when # DO  # we need to re-project?
# at least when a raster in a different CRS
HARV_CHM <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
HARV_CHM_df <- as.data.frame(HARV_CHM, xy=TRUE)

ggplot() +
  geom_sf(data = NE.States.Boundary.US, aes(color ="color"),
          show.legend = "line") +
  scale_color_manual(name = "", labels = "State Boundary",
                     values = c("color" = "gray18")) +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  scale_shape_manual(name = "", labels = "Fisher Tower",
                     values = c("shape" = 19)) +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  ggtitle("Fisher Tower location; BROKEN") +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()

crs(NE.States.Boundary.US) == crs(HARV_CHM)

HARV_CHM <- project(HARV_CHM, crs(NE.States.Boundary.US))
# now they match!
crs(NE.States.Boundary.US) == crs(HARV_CHM)

HARV_CHM_df <- as.data.frame(HARV_CHM, xy=TRUE)

# but this ggplot is still not illustrative. 
ggplot() +
  geom_sf(data = NE.States.Boundary.US, aes(color ="color"),
          show.legend = "line") +
  scale_color_manual(name = "", labels = "State Boundary",
                     values = c("color" = "gray18")) +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  scale_shape_manual(name = "", labels = "Fisher Tower",
                     values = c("shape" = 19)) +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  ggtitle("Fisher Tower location") +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()

# can I map just Mass.?
str(NE.States.Boundary.US)
str(NE.States.Boundary.US$STUSPS)
NE.States.Boundary.US$STUSPS
mass <- filter(NE.States.Boundary.US, STUSPS == "MA")



ggplot() +
  geom_sf(data = mass, aes(color ="black"),
          show.legend = "line") +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  scale_shape_manual(name = "", labels = "Fisher Tower",
                     values = c("shape" = 19)) +
  ggtitle("Just the Mass-holes") +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()

# now can we see the CHM?
ggplot() +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()

# i still can't see if it's working
ggplot() +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  geom_sf(data = mass, aes(color ="black"),
          show.legend = "line") +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  scale_shape_manual(name = "", labels = "Fisher Tower",
                     values = c("shape" = 19)) +
  ggtitle("Fisher Tower location") +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()

# try the landsat?
# column name should not start with a number
# does the lesson ever point this out?

HARV_Landsat <- rast("data/NEON-DS-Landsat-NDVI/HARV/2011/RGB/245_HARV_landRGB.tif")
str(HARV_Landsat)
nlyr(HARV_Landsat)
plotRGB(HARV_Landsat)
HARV_Landsat_df <- as.data.frame(HARV_Landsat, xy=TRUE)
str(HARV_Landsat_df)
new_names <- c("x", "y", "r", "g", "b")
names(HARV_Landsat_df) <- new_names
str(HARV_Landsat_df)


plotRGB(HARV_Landsat, 
        r = 1, g = 2, b = 3,
        stretch = "lin")

ggplot() +
  geom_raster(data = HARV_Landsat_df,
              aes(x = x, y = y, alpha = r)) + 
  coord_equal()

ggplot() +
  geom_raster(HARV_Landsat_df, aes(x=x, y=y, fill = g)) +
  coord_sf()







geom_sf(data = mass, aes(color ="black"),
        show.legend = "line") +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  scale_shape_manual(name = "", labels = "Fisher Tower",
                     values = c("shape" = 19)) +
  ggtitle("Fisher Tower location") +
  theme(legend.background = element_rect(color = NA)) +
  


### my names  - - - - - - - - 
mass <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/Boundary-US-State-Mass.shp")
new_england <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/Boundary-US-State-NEast.shp")
us_outline <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-Boundary-Dissolved-States.shp")
tower <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")

# sjer <- st_read("data/")



ggplot() +
  geom_sf(data=us_outline, color="blue") +
  geom_sf(data=mass, color="black") +
  geom_sf(data=tower, color="black") +
  coord_sf()

# they are not all 3 the same projection, but they map.
(crs(us_outline) == crs(mass)) == crs(tower)





# this is too silly
ggplot() +
  geom_sf(data = us_outline, fill = "gray", color="black") +
  geom_sf(data = mass, color="black") +
  geom_sf(data=tower, color="red") +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend="line", size = 1) +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  coord_sf()

# zoom in to
# prove the point that the CHM is there:
ggplot() +
  geom_sf(data = mass, color="black") +
  geom_sf(data=tower, color="red") +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend="line", size = 1) +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  coord_sf()


# is it the lines?
ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend="line", size = 1) +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  coord_sf()

# seems the raster needs to match the projection of the FIRST layer
ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend="line", size = 1) +
  geom_sf(data = mass, color="black") +
  geom_sf(data=tower, color="red") +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  coord_sf()
