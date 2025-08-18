# ep 6
# Open and plot a vector

library(pacman)
pacman::p_unload(pacman::p_loaded(), character.only = TRUE)

rm(list=ls())
current_episode <- 6

library(sf)
library(terra)
library(ggplot2)

aoi_boundary_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp")
class(aoi_boundary_HARV)
st_geometry_type((aoi_boundary_HARV))
st_crs(aoi_boundary_HARV)
crs(aoi_boundary_HARV)
st_bbox(aoi_boundary_HARV)




aoi_boundary_HARV
colnames(aoi_boundary_HARV)

# the world's least compelling shapefile
ggplot() +
  geom_sf(data=aoi_boundary_HARV, size=3, color="black", fill="cyan1")+
  ggtitle("AOI boundary plot") +
  coord_sf()

ggplot() +
  geom_sf(data=aoi_boundary_HARV, size=3, color="black", fill="cyan1")+
  ggtitle("AOI boundary plot no projection") 



# Challenge ########
# here's the load commands:
point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")
roads_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARV_roads.shp")

#
# Let's answer the following questions:
  
#  What type of R spatial object is created when you import each layer?
  
#  What is the CRS and extent for each object?
  
#  Do the files contain points, lines, or polygons?
  
#  How many spatial objects are in each file?


crs(point_HARV)
crs(roads_HARV)

st_geometry(point_HARV)
st_geometry(roads_HARV)

st_crs(point_HARV)

st_bbox(roads_HARV)
