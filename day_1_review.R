# potential day 1 review
# if everything is on schedule

# we like to clear our environment at the end of each lesson
rm(list=ls())

library(terra)
# more and more we will use terra functions

library(dplyr)
# I can't live without my %>% 


# open and visualize recent
# data and imagery from near Altadena
describe("data/20250112_185234_35_24f9_3B_udm2_clip.tif")

altadena <- rast("data/20250112_185234_35_24f9_3B_udm2_clip.tif")


summary(altadena)

plot(altadena$clear)
unique(altadena$clear)

# how can I see what the band names are?








# in a way that uses a dataframe?











# like this

altadena_df <- as.data.frame(altadena, xy=TRUE)
str(altadena_df)


colnames(altadena_df)

# so this is data that comes with Planet imagery
# that is produced by their machine vision robots


crs(altadena)
minmax(altadena)

nlyr(altadena)





# but that's not interesting at all. what's interesting is episodes 4 and 5
# where we do math and make a 3 color image.
# but this is college

# and these go to 8:
altadena_8b <- rast("data/20250112_185234_35_24f9_3B_AnalyticMS_8b_clip.tif")
summary(altadena_8b)


# rasters can have multiple layers and what the values represent 
# are often arbitrary!




plotRGB(altadena_8b, 
        r=1, g=2, b=3,
        stretch = "lin")


plotRGB(altadena_8b, 
        r=6, g=4, b=2,
        stretch = "lin")


plotRGB(altadena_8b, 
        r=8, g=3, b=1,
        stretch = "lin")


