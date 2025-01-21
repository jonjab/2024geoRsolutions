
# geospatial R episode 4
# Raster math
# CHM = how tall are your trees?

# Before we start: where will the trees be taller?
# Harvard or SJER?


rm(list=ls())

library(terra)
library(dplyr)
library(ggplot2)

describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

# lines 3 are exactly the same.
# data has been prepared to be exactly overlaid.

# fast ggplots
# (terra plots would be faster)

DTM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif") 
DTM_HARV_df <- as.data.frame(DTM_HARV, xy=TRUE)

DSM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif") 
DSM_HARV_df <-  as.data.frame(DSM_HARV, xy=TRUE)

ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dtmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  ggtitle("DTM") +
  coord_quickmap()

ggplot() +
  geom_raster(data = DSM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  ggtitle("DSM") +
  coord_quickmap()

# DSM is speckly. And goes higher. It's the tree tops. 
# this is where we left off in ep 3

# Canopy Height Models (CHMs)
# Raster subtraction method

CHM_HARV <- DSM_HARV - DTM_HARV

summary(CHM_HARV)
values(CHM_HARV) %>% summary()

str(CHM_HARV)

CHM_HARV_df <- as.data.frame(CHM_HARV, xy = TRUE)
str(CHM_HARV_df)

ggplot() +
  geom_raster(data = CHM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dsmCrop)) + 
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  coord_quickmap()

# remember episode 1? Let's look at a histogram of our CHM:
# to see the range of values
ggplot(CHM_HARV_df) +
  geom_histogram(aes(HARV_dsmCrop))

# does this pass the smell test for a forest in the US NE?

###########################
# Challenge: Exploratory data analysis
# 1. What is the min and maximum value for the Harvard Forest Canopy Height Model 
#    (CHM_HARV) that we just created?
# 2. What are two ways you can check this range of data for CHM_HARV?
# 3. What is the distribution of all the pixel values in the CHM?
# 4. Plot a histogram with 6 bins instead of the default and 
#    change the color of the histogram.
# 5. Plot the CHM_HARV raster using breaks that make sense for the data. 
#    Include an appropriate color palette for the data, plot title 
#    and no axes ticks / labels.


# 1. What is the min and maximum value for the Harvard Forest Canopy Height Model 
#    (CHM_HARV) that we just created?

summary(values(CHM_HARV))








# (zero to 33.43 m (ft?) )


# 2. What are two ways you can check this range of data for CHM_HARV?

minmax(CHM_HARV)


# 3. What is the distribution of all the pixel values in the CHM?
#    ie: what does the distribution look like? Normal?






# hint: distrobution = histogram




ggplot(CHM_HARV_df) +
  geom_histogram(aes(HARV_dsmCrop))








# some open areas of grass / low shrubs
# lots of small trees
# a few really tall ones




# 4. Plot a histogram with 6 bins instead of the default and 
#    change the color of the histogram.



# use Help!






ggplot(CHM_HARV_df) +
  geom_histogram(aes(HARV_dsmCrop), 
                 bins = 6, 
                 color = "red")

# no that's not it.



# 5. Plot the CHM_HARV raster using breaks that make sense for the data. 
#    Include an appropriate color palette for the data, plot title 
#    and no axes ticks / labels.




# remember episode 1?
tree_bins <- c(1, 5, 10, 30)

str(CHM_HARV_df)

CHM_HARV_binned_df <- CHM_HARV_df %>% 
  mutate(tree_heights = cut(HARV_dsmCrop, breaks=tree_bins))

# top of my head

ggplot() +
  geom_raster(data = CHM_HARV_binned_df , 
              aes(x = x, y = y, fill = tree_heights)) + 
  scale_fill_discrete(name = "Canopy Height") + 
  ggtitle("Canopy Height: Harvard Test Forest") +
  coord_quickmap()

# a good opportunity for Brewer in the autocomplete on the fill
ggplot() +
  geom_raster(data = CHM_HARV_binned_df , 
              aes(x = x, y = y, fill = tree_heights)) + 
  scale_fill_brewer(name = "Canopy Height", type = "seq") + 
  ggtitle("Canopy Height: Harvard Test Forest") +
  coord_quickmap()

# let's try again
tree_bins <- c(0, 1, 5, 10, 30, 40)

CHM_HARV_binned_df <- CHM_HARV_df %>% 
  mutate(tree_heights = cut(HARV_dsmCrop, breaks=tree_bins))

ggplot() +
  geom_raster(data = CHM_HARV_binned_df , 
              aes(x = x, y = y, fill = tree_heights)) + 
  scale_fill_brewer(name = "Canopy Height", type = "seq") + 
  ggtitle("Canopy Height: Harvard Test Forest") +
  coord_quickmap()

# the canonical solution:
custom_bins <- c(0, 10, 20, 30, 40)
CHM_HARV_df <- CHM_HARV_df %>%
  mutate(canopy_discrete = cut(HARV_dsmCrop, 
                               breaks = custom_bins))

ggplot() +
  geom_raster(data = CHM_HARV_df , aes(x = x, y = y,
                                       fill = canopy_discrete)) + 
  scale_fill_manual(values = terrain.colors(4)) + 
  coord_quickmap()


##### Back to the lesson
# the 2nd way to do raster math
# green / red stickies: whose laptops were slow?

# lapp() is supposed to be faster
# outputRaster <- lapp(x, fun=functionName)

CHM_ov_HARV <- lapp(sds(list(DSM_HARV, DTM_HARV)), 
                    fun = function(r1, r2) { return( r1 - r2) })
CHM_ov_HARV_df <- as.data.frame(CHM_ov_HARV, xy = TRUE)

ggplot() +
  geom_raster(data = CHM_ov_HARV_df, 
              aes(x = x, y = y, fill = HARV_dsmCrop)) + 
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  coord_quickmap()



# Saving our work
# exporting a geotiff for later analysis, viz, etc.
# this is the data -- not the viz!

writeRaster(CHM_ov_HARV, "CHM_HARV.tiff",
            filetype="GTiff",
            overwrite=TRUE,
            NAflag=-9999)



# right-click to save your ggplot output. OR:

my_viz <- ggplot() +
  geom_raster(data = CHM_ov_HARV_df, 
              aes(x = x, y = y, fill = HARV_dsmCrop)) + 
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  coord_quickmap()

ggsave(plot=my_viz, "my_viz.png")



# final challenge
# ##############################
# Use SJER DSM and DTM data 
# from ep 2 (Plot Raster Data)

# Don’t forget to check the CRSs and units of the data.
#
# 1 Create a CHM from the two raster layers and 
# 2 check to make sure the data are what you expect.
# 3 Plot the CHM from SJER.
# 4 Export the SJER CHM as a GeoTIFF. -- can skip for time
# 5 Compare the vegetation structure of the Harvard Forest and 
#   San Joaquin Experimental Range.


# reload objects from ep. 2

# import DTM
DTM_SJER <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmCrop.tif")

# import DSM data
DSM_SJER <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")








# 0 Do projections match?
crs(DTM_SJER) == crs(DSM_SJER)


#  1 Create a CHM from the two raster layers
CHM_SJER <- DSM_SJER - DTM_SJER



# 2 check to make sure the data are what you expect.
plot(CHM_SJER)
summary(CHM_SJER)

# this seems to pass the smell test
# trees between 0 and 28 m (ft?)

# 3 Plot the CHM from SJER.
CHM_SJER_df <- as.data.frame(CHM_SJER, xy=TRUE) 




# 5 Compare the vegetation structure of the Harvard Forest and 
#   San Joaquin Experimental Range.

summary(CHM_SJER)
summary(CHM_HARV)



# there's almost no trees in the desert.


