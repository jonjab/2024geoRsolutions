# episode 9
# dealing with CRSs

library(pacman)
pacman::p_unload(pacman::p_loaded(), character.only = TRUE)

rm(list=ls())
current_episode <- 9

library(sf)
library(terra)
library(ggplot2)
library(dplyr)

# Read US Boundary File
# we didn't look at this last week:
state_boundary_US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-State-Boundaries-Census-2014.shp") %>% 
  st_zm() # remove z-values


# what's that st_zm() for?
# it removes z-values that for some
# reason were attached to this file

ggplot() +
  geom_sf(data = state_boundary_US) +
  ggtitle("Map of Contiguous State Boundaries") +
  coord_sf()


# US Boundary Layer
# to visually 'punch out' an outline

country_boundary_US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-Boundary-Dissolved-States.shp") %>% 
  st_zm() # remove z-values



ggplot() +
  geom_sf(data = state_boundary_US, color = "gray60") +
  geom_sf(data = country_boundary_US, color = "black", alpha = 0.75, linewidth = 2) +
  ggtitle("Silly Map of US") +
  coord_sf()

# Read point vector with one data point on our study area
# our tower location (from ep. 8):
point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")

# Don't do what the lessons says, but use the approach of ep 1 to get crs
crs(point_HARV, proj = TRUE)
crs(state_boundary_US, proj = TRUE)
crs(country_boundary_US, proj = TRUE)


# this is the narrative
# it don't work.
# typo in the solution!!!
st_crs(state_boundary_US)$proj4string


# CRS Units - View Object Extent
# you will see the difference in units:
st_bbox(point_HARV)
st_bbox(state_boundary_US)

# Reproject Vector Data or No?

# in this case we don't have to!
# (fwiw this also works without the coord_sf())
ggplot() +
  geom_sf(data = state_boundary_US, color = "gray60") +
  geom_sf(data = country_boundary_US, linewidth = 2, alpha = 0.25, color = "black") +
  geom_sf(data = point_HARV, shape = 19, color = "purple") +
  ggtitle("Less silly map with Tower") +
  coord_sf()


# coord_sf() takes the first layer with a crs defined.


# aside: make a ggplot showing each of
# the 25 possible shapes of points
# (see the ggplot2 documentation for geom_point)
# https://ggplot2.tidyverse.org/reference/geom_point.html
# (or geom_sf, which is what we use here)



# Challenge - Plot Multiple Layers of Spatial Data
# Create a map of the North Eastern United States as follows:
#   
# 1 Import and plot Boundary-US-State-NEast.shp. 
#   Adjust line width as necessary.
# 
# 2 Layer the Fisher Tower (in the NEON Harvard Forest site) point location point_HARV onto the plot.
# 
# 3 Add a title.
# 
# 4 Add a legend that shows both the state boundary (as a line) 
#   and the Tower location point.

# 1 Read in the NEast boundary layer
NE.States.Boundary.US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/Boundary-US-State-NEast.shp") %>%
  st_zm()

# 1 plot
ggplot() +
  geom_sf(data = NE.States.Boundary.US, color = "gray18") +
  ggtitle("North Eastern US State Boundaries") +
  coord_sf()

# 2 plot the Fisher Tower point
ggplot() +
  geom_sf(data = NE.States.Boundary.US, color = "gray18") +
  geom_sf(data = point_HARV, shape = 19, color = "purple") +
  ggtitle("Harvard Tower Location") +
  coord_sf()

# 3 Add a title to the plot
# (we've had one all along, because that's just good form)

# 4 Add a legend that shows both the state boundary (as a line)

ggplot() +
  geom_sf(data = NE.States.Boundary.US,
          show.legend = "line", aes(color ="color")) +
  scale_color_manual(name = "", labels = "State Boundary",
                     values = c("color" = "gray18")) +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  scale_shape_manual(name = "", labels = "Fisher Tower",
                     values = c("shape" = 19)) +
  ggtitle("Fisher Tower location") +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()

# the color = color and shape = shape force them into the legend

# everything from here down
# is improvisation to make an example
# where the overlay fails.



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
# because the point covers the CHM
ggplot() +
  geom_sf(data = NE.States.Boundary.US, aes(color ="color"),
          show.legend = "line") +
  scale_color_manual(name = "", labels = "State Boundary",
                     values = c("color" = "gray18")) +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  ggtitle("Fisher Tower location") +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()

# can I map just Mass.?
str(NE.States.Boundary.US)
str(NE.States.Boundary.US$STUSPS)
NE.States.Boundary.US$STUSPS
mass <- filter(NE.States.Boundary.US, STUSPS == "MA")


# black is missing
ggplot() +
  geom_sf(data = mass, aes(color ="black"),
          show.legend = "line") +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  scale_shape_manual(name = "", labels = "Fisher Tower",
                     values = c("shape" = 19)) +
  ggtitle("Just Massachusetts") +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()

# now can we see the CHM?
ggplot() +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()

ggplot() +
  geom_sf(data = mass, aes(color ="black"),
          show.legend = "line") +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  scale_shape_manual(name = "", labels = "Fisher Tower",
                     values = c("shape" = 19)) +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  theme(legend.background = element_rect(color = NA)) +
  ggtitle("Just Massachusetts") +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()
  


### my names  - - - - - - - - 
mass <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/Boundary-US-State-Mass.shp")
new_england <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/Boundary-US-State-NEast.shp")
us_outline <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-Boundary-Dissolved-States.shp")
tower <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")
lines_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARV_roads.shp")


ggplot() +
  geom_sf(data=us_outline, color="blue") +
  geom_sf(data=mass, color="black") +
  geom_sf(data=tower, color="black") +
  coord_sf()

# they are not all 3 the same projection, but they map.
(crs(us_outline) == crs(mass)) == crs(tower)


# zoom the graphic window to
# prove the point that the CHM is there:
ggplot() +
  geom_sf(data = mass, color="black") +
  geom_sf(data=tower, color="red", size=10) +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend="line", linewidth  = 1) +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  coord_sf()

# here is the counterexample:
# it seems the raster needs to match the projection of the FIRST layer
ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend="line", linewidth  = 1) +
  geom_sf(data = mass, color="black") +
  geom_sf(data=tower, color="red") +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  coord_sf()

# st_transform() is the vector version of project()




ggplot() +
  geom_sf(data = mass, color="black") +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend="line", linewidth  = 1) +
  geom_sf(data=tower, color="red") +
  geom_raster(data = HARV_CHM_df, aes(x=x, y=y, fill = HARV_chmCrop)) +
  coord_sf()


