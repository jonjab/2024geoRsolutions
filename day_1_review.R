# potential day 1 review
# if everything is on schedule

rm(list=ls())

library(terra)

# open and visualize recent
# imagery from Altadena

altadena <- rast("planet/20250112_185236_53_24f9_3B_udm2_clip.tif")
summary(altadena)

plot(altadena$clear)
unique(altadena$clear)

crs(altadena)

altadena_8b <- rast("planet/20250112_185236_53_24f9_3B_AnalyticMS_8b_clip.tif")
summary(altadena_8b)


# rasters can have multiple layers and what the values represent 
# are often arbitrary!