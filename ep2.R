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
