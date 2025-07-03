# episode 10
# from csv to vector

rm(list=ls())
current_episode <- 10

# library(sf)
# library(terra)
# library(ggplot2)
# library(dplyr)

# Import csv that has x, y point locations
plot_locations_HARV <-
  read.csv("data/NEON-DS-Site-Layout-Files/HARV/HARV_PlotLocations.csv")

str(plot_locations_HARV)

# Our dataset has columns "easting" and "northing" (UTM coordinates)
# Additionally, "geodeticDa" and "utmZone" contain the datum and projection
# Do we have everything we need to know about the crs? Yes!
names(plot_locations_HARV)
View(plot_locations_HARV)

# We know that our datum is WGS84 and our projection is UTM18N
# We do a little Google search for "WGS84 UTM18N" and find the
# corresponding EPSG code is 32618 https://epsg.io/32618
# We use it to transform our dataframe to a vector dataset using st_as_sf()

plot_locations_sp_HARV <- st_as_sf(plot_locations_HARV,
                                   coords = c("easting", "northing"),
                                   crs = 32618)
crs(plot_locations_sp_HARV, proj = TRUE)

# Of course, if I already had a vector with this crs, I could use that crs
point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")
crs(point_HARV, proj = TRUE)

# The same as before, with same result, but using the crs of another vector dataset
plot_locations_sp_HARV <- st_as_sf(plot_locations_HARV,
                                   coords = c("easting", "northing"),
                                   crs = crs(point_HARV))


## Plot our data
ggplot() +
  geom_sf(data = plot_locations_sp_HARV) +
  ggtitle("Map of Plot Locations")

## Plot multiple vectors - We can skip it
# Here the idea is ggplot increases the boundaries
# of our plot to graph all objectecs

# Read AOI polygon
aoi_boundary_HARV <- st_read(
  "data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp")

# Only AOI plot
ggplot() +
  geom_sf(data = aoi_boundary_HARV)

# ggplot expands extent to include all objects
ggplot() +
  geom_sf(data = aoi_boundary_HARV) +
  geom_sf(data = plot_locations_sp_HARV) +
  ggtitle("AOI Boundary Plot")



## CHALLENGE (5 min)

# 1. We have new data points contained in the data/NEON-DS-Site-Layout-Files/HARV/HARV_2NewPhenPlots.csv
# Read the csv into R

# 2. Examine the data. Do you know what columns are the X and Y coordinate locations?
# Do you know what is the crs of this data?

# 3. The importance of metadata! How do we know which CRS to use?
# As the columns are called lon, lat, should we asume it's the common EPSG:4326?

# 4. Plot the new two points with our previous locations

# Read data and take a look to the values
newplot_locations_HARV <-
  read.csv("data/NEON-DS-Site-Layout-Files/HARV/HARV_2NewPhenPlots.csv")
str(newplot_locations_HARV)

# Convert to spatial dataframe
newPlot.Sp.HARV <- st_as_sf(newplot_locations_HARV,
                            coords = c("decimalLon", "decimalLat"),
                            crs = 4326)

# Create plot with all points
ggplot() +
  geom_sf(data = plot_locations_sp_HARV, color = "orange") +
  geom_sf(data = newPlot.Sp.HARV, color = "lightblue") +
  ggtitle("Map of All Plot Locations")

# Or adding legends
ggplot() +
  geom_sf(data = plot_locations_sp_HARV, mapping = aes(color = "Original")) +
  geom_sf(data = newPlot.Sp.HARV, mapping = aes(color = "New")) +
  scale_color_manual(values =  c("Original" = "orange", "New" = "lightblue")) + 
  ggtitle("Map of All Plot Locations")

## Export to an ESRI shapefile
st_write(plot_locations_sp_HARV,
         "data/PlotLocations_HARV.shp", append = FALSE)
# I had to add the append = FALSE argument as I already had the file and needed to replace it

