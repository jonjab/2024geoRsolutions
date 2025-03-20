# ep 5
# color!
# ie: multi-band rasters


rm(list=ls())

library(terra)
library(ggplot2)
library(dplyr)

# if we did the review, we already saw an 8-band image
# LANDSAT 8 = 11 bands


RGB_band1_HARV <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", 
       lyrs = 1)

# fast. meaningless
plot(RGB_band1_HARV)

# lots of typing. also meaningless  
RGB_band1_HARV_df  <- as.data.frame(RGB_band1_HARV, xy = TRUE)
str(RGB_band1_HARV_df)
ggplot() +
  geom_raster(data = RGB_band1_HARV_df,
              aes(x = x, y = y, alpha = HARV_RGB_Ortho_1)) + 
  coord_quickmap()

## challenge: what's it about?
# dimensions, CRS, resolution, min and max values, and band number
# band number is from our memory: it's what we loaded.

# everything except for band number:
RGB_band1_HARV



# or:

crs(RGB_band1_HARV)
# utm 18n


# min and max
values(RGB_band1_HARV) %>% summary()


# at this point I may skip a big chunk and go straight to:
# Raster Stacks

RGB_stack_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

# you can see there's 3 layers
RGB_stack_HARV

# ##########
# skip the ggplots?

# Create a 3 band image

plotRGB(RGB_stack_HARV, r=1, g=2, b=3)

# stretch it out
plotRGB(RGB_stack_HARV, 
        r=1, g=2, b=3,
        scale = 800, 
        stretch = "lin")

plotRGB(RGB_stack_HARV, 
        r=1, g=2, b=3,
        scale = 800, 
        stretch = "hist")

summary(RGB_stack_HARV)

# I have no idea what 'scale' is doing here
# # we already know it goes 0 - 255.


plotRGB(RGB_stack_HARV, 
        r=1, g=2, b=3,
        stretch = "lin")

plotRGB(RGB_stack_HARV, 
        r=1, g=2, b=3,
        stretch = "hist")

# ################################
# Challenge: nodata in RasterStacks

HARV_Ortho_wNA <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")

HARV_Ortho_wNA

# 1 View the files attributes. Are there NoData values assigned for this file?
# 2 If so, what is the NoData Value?
# 3 How many bands does it have?
# 4 Load the multi-band raster file into R.
# 5 Plot the object as a true color image.
# 6 What happened to the black edges in the data?
# 7 What does this tell us about the difference in the data structure between HARV_Ortho_wNA.tif and HARV_RGB_Ortho.tif 
# (R object RGB_stack). How can you check?



# 1 View the files attributes. Are there NoData values assigned for this file?
values(HARV_Ortho_wNA) %>% summary()




# plenty of them

# 2 If so, what is the NoData Value?



describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")

# -9999


# 3 How many bands does it have?
# 3. I saw that in summary()

# 4 Load the multi-band raster file into R.
# I did that prematurely

# 5 Plot the object as a true color image.




plotRGB(HARV_Ortho_wNA, r=1, g=2, b=3)


# 6 What happened to the black edges in the data?


# they be gone by default. 


# 7 What does this tell us about the difference in the data structure 
# between HARV_Ortho_wNA.tif and HARV_RGB_Ortho.tif 
# (R object RGB_stack). How can you check?
