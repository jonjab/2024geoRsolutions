# ep 5
# color!
# ie: multi-band rasters


rm(list=ls())

library(terra)

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

str(RGB_band1_HARV_df)
str(RGB_band1_HARV)

# min and max
values(RGB_band1_HARV) %>% summary()

crs(RGB_band1_HARV)
# utm 18n

