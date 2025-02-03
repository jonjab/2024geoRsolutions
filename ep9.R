# episode 9
# dealing with CRSs

rm(list=ls())

library(sf)
library(terra)
library(ggplot2)

state_boundary_US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-State-Boundaries-Census-2014.shp") %>%
  st_zm()

mass <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/Boundary-US-State-Mass.shp")
# new_england <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/Boundary-US-State-NEast.shp")
us_outline <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-Boundary-Dissolved-States.shp")
tower <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")

sjer <- st_read("data/")



ggplot() +
  geom_sf(data=us_outline, color="blue") +
  geom_sf(data=mass, color="black") +
  geom_sf(data=tower, color="black") +
  coord_sf()

# they are not all 3 the same projection, but they map.
(crs(us_outline) == crs(mass)) == crs(tower)


# but a raster in a different projection breaks it.
HARV_CHM <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
HARV_CHM_df <- as.data.frame(HARV_CHM, xy=TRUE)
str(HARV_CHM_df)

lines_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARV_roads.shp")


ggplot() +
  geom_sf(data = us_outline, fill = "gray", color="black") +
  geom_sf(data = mass, color="black") +
  geom_sf(data=tower, color="black") +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  coord_sf()

crs(us_outline) == crs(HARV_CHM)

HARV_CHM <- project(HARV_CHM, crs(us_outline))
HARV_CHM_df <- as.data.frame(HARV_CHM, xy=TRUE)


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
