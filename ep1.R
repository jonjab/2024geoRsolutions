library(terra)
library(ggplot2)
library(dplyr)

describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

# you can save this output,
# later we will save the CRS and extent
# using this same method
HARV_dsmCrop_info <- capture.output(
  describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
)

HARV_dsmCrop_info
str(HARV_dsmCrop_info)

DSM_HARV <-
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

DSM_HARV

summary(values(DSM_HARV))

# ggplot wants dataframes
# for vector data, we'll want to control
# for textasfactor
DSM_HARV_df <- as.data.frame(DSM_HARV, xy = TRUE)
DSM_HARV_df 

str(DSM_HARV_df)

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_viridis_c() +
  coord_quickmap()

# plot is often faster:
plot(DSM_HARV)

# we need to be cognizant of our CRS:
crs(DSM_HARV, proj = TRUE)

# this is a single-band / layer raster
nlyr(DSM_HARV)

# no data
# the example uses a different piece of data than we have used
# so far:
# from what's embedded in the lesson:
    RGB_stack <-
      rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")
    
    # aggregate cells from 0.25m to 2m for plotting to speed up the lesson and
    # save memory
    RGB_2m <- raster::aggregate(RGB_stack, fact = 8, fun = median)
    # fix data values back to integer datatype
    values(RGB_2m) <- as.integer(round(values(RGB_2m)))
    
    # convert to a df for plotting using raster's built-in method
    RGB_2m_df  <- as.data.frame(RGB_2m, xy = TRUE)
    # make colnames easy to ref
    names(RGB_2m_df) <- c('x', 'y', 'red', 'green', 'blue')
    
    ggplot() +
      geom_raster(data = RGB_2m_df , aes(x = x, y = y, fill = red),
                  show.legend = FALSE) +
      scale_fill_gradient(low = 'black', high = "red") +
      ggtitle("Orthographic Imagery", subtitle = 'Red Band') +
      coord_quickmap()




ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_viridis_c() +
  coord_quickmap()

# what's the value of NoData?
describe(sources(DSM_HARV))
sources(DSM_HARV)

# that's different than bad data
# this highlights elevations > 400 whatevers:
# reclassify raster to ok/not ok
DSM_highvals <- classify(DSM_HARV, 
                         rcl = matrix(c(0, 400, NA_integer_, 400, 420, 1L), 
                                      ncol = 3, byrow = TRUE), 
                         include.lowest = TRUE)
DSM_highvals <- as.data.frame(DSM_highvals, xy = TRUE)

DSM_highvals <- DSM_highvals[!is.na(DSM_highvals$HARV_dsmCrop), ]

ggplot() +
  geom_raster(data = DSM_HARV_df, aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_viridis_c() +
  # use reclassified raster data as an annotation
  annotate(geom = 'raster', x = DSM_highvals$x, y = DSM_highvals$y, 
           fill = scales::colour_ramp('deeppink')(DSM_highvals$HARV_dsmCrop)) +
  ggtitle("Elevation Data", subtitle = "Highlighting values > 400m") +
  coord_quickmap()


# historgrams to find outliers:
ggplot() +
  geom_histogram(data = DSM_HARV_df, aes(HARV_dsmCrop))

# default bins is 30. you can make more or less:
ggplot() +
  geom_histogram(data = DSM_HARV_df, aes(HARV_dsmCrop), bins = 40)


# final challenge:
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")
