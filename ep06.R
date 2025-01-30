# ep 6
# vectors

rm(list=ls())

library(sf)
library(terra)

aoi_boundary_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp")
class(aoi_boundary_HARV)
st_geometry_type((aoi_boundary_HARV))
st_crs(aoi_boundary_HARV)
crs(aoi_boundary_HARV)
st_bbox(aoi_boundary_HARV)

aoi_boundary_HARV
colnames(aoi_boundary_HARV)

ggplot() +
  geom_sf(data=aoi_boundary_HARV, size=3, color="black", fill="cyan1")+
  ggtitle("AOI boundary plot") +
  coord_sf()


point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")
roads_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARV_roads.shp")

crs(point_HARV)
crs(roads_HARV)

st_geometry(point_HARV)
st_geometry(roads_HARV)

# ep 7 starts here.
ncol(lines_HARV)
colnames(lines_HARV)


# challenge #########
# # 2 Who owns it?
point_HARV$Ownership

# # 3
colnames(point_HARV)
