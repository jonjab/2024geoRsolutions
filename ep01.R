library(terra)
library(ggplot2)
library(dplyr)

describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

HARV_dsmCrop_info <- capture.output(
  describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
)
HARV_dsmCrop_info

DSM_HARV <-
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

DSM_HARV

summary(DSM_HARV)
summary(values(DSM_HARV))


DSM_HARV_df <- as.data.frame(DSM_HARV, xy = TRUE)
# later on we'll need to remember strings.as.factors = TRUE

str(DSM_HARV_df)

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_viridis_c() +
  coord_quickmap()

# faster:
plot(DSM_HARV)

# all of episode 3 is about this:
crs(DSM_HARV, proj = TRUE)

# gotcha in the challenge:
# the pixel size is in meters. The crs doesn't say anything
# about the units of the pixels themselves. This map could be
# 300 - 400 Smoots.

# order counts here. 
minmax(DSM_HARV)
min(values(DSM_HARV))
max(values(DSM_HARV))

nlyr(DSM_HARV)


# no data demonstration code - not being taught
# Use stack function to read in all bands
RGB_stack <-
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

# aggregate cells from 0.25m to 2m for plotting to speed up the lesson and
# save memory
RGB_2m <- aggregate(RGB_stack, fact = 8, fun = median)
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


# demonstration code - not being taught
# here's how to make nodata transparent:
RGB_2m_df_nd <- RGB_2m_df
# convert the three rgb values to hex codes
RGB_2m_df_nd$hex <- rgb(RGB_2m_df_nd$red,
                        RGB_2m_df_nd$green,
                        RGB_2m_df_nd$blue, maxColorValue = 255)
# set black hex code to NA
RGB_2m_df_nd$hex[RGB_2m_df_nd$hex == '#000000'] <- NA_character_

ggplot() +
  geom_raster(data = RGB_2m_df_nd, aes(x = x, y = y, fill = hex)) +
  scale_fill_identity() +
  ggtitle("Orthographic Imagery", subtitle = "All bands") +
  coord_quickmap()


# I always wanted to know how to make this one:
# To highlight `NA` values in ggplot, alter the `scale_fill_*()` layer to contain 
# a colour instruction for `NA` values, like `scale_fill_viridis_c(na.value = 'deeppink')`

# demonstration code
# function to replace 0 with NA where all three values are 0 only
RGB_2m_nas <- app(RGB_2m, 
                  fun = function(x) {
                    if (sum(x == 0, na.rm = TRUE) == length(x))
                      return(rep(NA, times = length(x)))
                    x
                  })
RGB_2m_nas <- as.data.frame(RGB_2m_nas, xy = TRUE, na.rm = FALSE)

ggplot() +
  geom_raster(data = RGB_2m_nas, aes(x = x, y = y, fill = HARV_RGB_Ortho_3)) +
  scale_fill_gradient(low = 'grey90', high = 'blue', na.value = 'deeppink') +
  ggtitle("Orthographic Imagery", subtitle = "Blue band, with NA highlighted") +
  coord_quickmap()

# memory saving
rm(RGB_2m, RGB_stack, RGB_2m_df_nd, RGB_2m_df, RGB_2m_nas)


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

# memory saving
rm(DSM_highvals)


# back to the lesson type-and-talk code:
ggplot() +
  geom_histogram(data = DSM_HARV_df, aes(HARV_dsmCrop))
# this explains the very few hot-pink > 400 pixels

ggplot() +
  geom_histogram(data = DSM_HARV_df, aes(HARV_dsmCrop), bins = 40)


##### The final challenge:
# Use describe() to determine the following 
# about the NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif file:
  
#  1. Does this file have the same CRS as DSM_HARV?
#  2. What is the NoDataValue?
#  3. What is resolution of the raster data?
#  4. How large would a 5x5 pixel area be on the Earth’s surface?
#  5. Is the file a multi- or single-band raster?

# we end as we begin:
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")



