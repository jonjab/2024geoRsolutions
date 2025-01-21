# episode 2

rm(list=ls())

library(terra)
library(dplyr)
library(ggplot2)

# objects we'll need from ep 1
DSM_HARV_df <-
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif") %>% 
  as.data.frame(xy=TRUE)

# slice the data into 3 classes
DSM_HARV_df <- DSM_HARV_df %>%
  mutate(fct_elevation = cut(HARV_dsmCrop, breaks = 3))

ggplot() +
  geom_bar(data = DSM_HARV_df, aes(fct_elevation))

# what are the cutoffs?
# (they're also on the plot
# but this is a good review of ranges expressed with
# a left paren and a right bracket)
unique(DSM_HARV_df$fct_elevation)

# adn you can see the distribution:
# roughly normal for 3 bins
DSM_HARV_df %>%
  count(fct_elevation)

# custom bins would make things easier to read:
# 4 values = 3 bins
# this does obfuscate that there is nothing 
# over 416
custom_bins <- c(300, 350, 400, 450)

DSM_HARV_df <- DSM_HARV_df %>%
  mutate(fct_elevation_2 = cut(HARV_dsmCrop, breaks = custom_bins))

unique(DSM_HARV_df$fct_elevation_2)

ggplot() +
  geom_bar(data = DSM_HARV_df, aes(fct_elevation_2))

# this visualization emphasizes arbitrary values rather than the
# normality of the dataset
DSM_HARV_df %>%
  count(fct_elevation_2)

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation_2)) + 
  coord_quickmap()

# plot it was a cartographically better color scheme
terrain.colors(3)

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation_2)) + 
  scale_fill_manual(values = terrain.colors(3)) +
    coord_quickmap()

# we can store that color scheme in an object
# for re-use. Like copying the symbology from
# layer-to-layer in Esri

my_col <- terrain.colors(3)

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation_2)) + 
  scale_fill_manual(values = my_col) +
  coord_quickmap()

# and we can turn off the axis labels:
#     theme(axis.title = element_blank()
# and label the legend
#     name = "Elevation"

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation_2)) + 
  scale_fill_manual(values = my_col, name = "Elevation") +
  theme(axis.title = element_blank()) +
  coord_quickmap()

# challenge: More breaks!
#   1: 6 breaks equally divided
#   2: axis labels
#   3: a title

DSM_HARV_df <- DSM_HARV_df %>%
  mutate(fct_elevation_6 = cut(HARV_dsmCrop, breaks = 6))


ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation_6)) + 
  scale_fill_manual(values = terrain.colors(6), name = "Elevation") +
  ggtitle("Classified Elevation Map - NEON Harvard Forest Field Site") +
  xlab("UTM Easting Coordinate (m)") +
  ylab("UTM Northing Coordinate (m)") + 
  coord_quickmap()
  
# (can also name the color scheme as above)
my_col <- terrain.colors(6)


ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                       fill = fct_elevation_6)) + 
  scale_fill_manual(values = my_col, name = "Elevation") + 
  ggtitle("Classified Elevation Map - NEON Harvard Forest Field Site") +
  xlab("UTM Easting Coordinate (m)") +
  ylab("UTM Northing Coordinate (m)") + 
  coord_quickmap()



### Layering rasters
# (with transparency)

DSM_hill_HARV <-
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")

DSM_hill_HARV

DSM_hill_HARV_df <- as.data.frame(DSM_hill_HARV, xy = TRUE) 

str(DSM_hill_HARV_df)

DSM_hill_HARV_df

# the basic ggplot as we did it before is illustrative:
# it's a scale of +1 to -1
ggplot() +
  geom_raster(data = DSM_hill_HARV_df, 
              aes(x = x, y = y, fill = HARV_DSMhill)) + 
  coord_quickmap()

# the plot as in the lesson
# alpha controls transparency. 
ggplot() +
  geom_raster(data = DSM_hill_HARV_df,
              aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  scale_alpha(range =  c(0.15, 0.65), guide = "none") + 
  coord_quickmap()

ggplot() +
  geom_raster(data = DSM_hill_HARV_df,
              aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  scale_alpha(range =  c(0.05, 0.95), guide = "none") + 
  coord_quickmap()

ggplot() +
  geom_raster(data = DSM_hill_HARV_df,
              aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  scale_alpha(range =  c(0.65, 0.95), guide = "none") + 
  coord_quickmap()


# now we're at the point where we can put one
# on top of the other:
ggplot() +
  geom_raster(data = DSM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dsmCrop)) + 
  geom_raster(data = DSM_hill_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DSMhill)) +  
  scale_fill_viridis_c() +  
  scale_alpha(range = c(0.15, 0.65), guide = "none") +  
  ggtitle("Elevation with hillshade") +
  coord_quickmap()

# bonus challenge:
# make the elevation binned again

str(DSM_HARV_df)

ggplot() +
  geom_raster(data = DSM_HARV_df , 
              aes(x = x, y = y, 
                  fill = fct_elevation_6)) + 
  geom_raster(data = DSM_hill_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DSMhill)) +  
  scale_fill_viridis_d() +  
  scale_alpha(range = c(0.15, 0.65), guide = "none") +  
  ggtitle("Binned Elevation with hillshade") +
  coord_quickmap()




### Lesson challenge:
## do all the same for San Joaquin LTER


# CREATE DSM MAPS

# import DSM data
DSM_SJER <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")

# convert to a df for plotting
DSM_SJER_df <- as.data.frame(DSM_SJER, xy = TRUE)

# import DSM hillshade
DSM_hill_SJER <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmHill.tif")

# convert to a df for plotting
DSM_hill_SJER_df <- as.data.frame(DSM_hill_SJER, xy = TRUE)

# Build Plot
ggplot() +
  geom_raster(data = DSM_SJER_df, 
              aes(x = x, y = y, 
                  fill = SJER_dsmCrop,
                  alpha = 0.8)) + 
  geom_raster(data = DSM_hill_SJER_df, 
              aes(x = x, y = y, 
                  alpha = SJER_dsmHill)) +
  scale_fill_viridis_c() +
  guides(fill = guide_colorbar()) +
  scale_alpha(range = c(0.4, 0.7), guide = "none") +
  # remove grey background and grid lines
  theme_bw() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) +
  xlab("UTM Easting Coordinate (m)") +
  ylab("UTM Northing Coordinate (m)") +
  ggtitle("DSM with Hillshade") +
  coord_quickmap()



# CREATE DTM MAP
# qualitatively: what's the difference?



# import DTM
DTM_SJER <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmCrop.tif")
DTM_SJER_df <- as.data.frame(DTM_SJER, xy = TRUE)

# DTM Hillshade
DTM_hill_SJER <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmHill.tif")
DTM_hill_SJER_df <- as.data.frame(DTM_hill_SJER, xy = TRUE)

# there's a bunch of extra formatting stuff in here that's
# kind of introduced on the fly:
ggplot() +
  geom_raster(data = DTM_SJER_df ,
              aes(x = x, y = y,
                  fill = SJER_dtmCrop,
                  alpha = 2.0)) +
  geom_raster(data = DTM_hill_SJER_df,
              aes(x = x, y = y,
                  alpha = SJER_dtmHill)) +
  scale_fill_viridis_c() +
  guides(fill = guide_colorbar()) +
  scale_alpha(range = c(0.4, 0.7), guide = "none") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  ggtitle("DTM with Hillshade") +
  coord_quickmap()

# DSM = first return. treetops. bumpy
# DTM = final return. bare earth. smooth

# that's the opening cartoon in episode 3