# ep13
# creating publication quality graphics

# customizing raster plots using themes in ggplot2 package

rm(list=ls())
current_episode <- 13

library(terra)
library(ggplot2)
library(tidyr)
library(RColorBrewer)

#install.packages("RColorBrewer") if necessary 

# objects from last time
NDVI_HARV_path <- "data/NEON-DS-Landsat-NDVI/HARV/2011/NDVI"
all_NDVI_HARV <- list.files(NDVI_HARV_path,
                            full.names = TRUE,
                            pattern = ".tif$")

NDVI_HARV_stack <- rast(all_NDVI_HARV)
NDVI_HARV_stack_df <- as.data.frame(NDVI_HARV_stack, xy = TRUE) %>%
  pivot_longer(-(x:y), names_to = "variable", values_to = "value")

# episode 13 starts
ggplot() +
  geom_raster(data=NDVI_HARV_stack_df, aes(x=x, y=y, fill=value)) +
  facet_wrap(~variable)+
  ggtitle("Landsat NDVIs", subtitle = "NEON Harvard Forest")


# first get rid of everything
# theme_void() removes all the axis labels, ticks, and background
ggplot() +
  geom_raster(data=NDVI_HARV_stack_df, aes(x=x, y=y, fill=value)) +
  facet_wrap(~variable)+
  ggtitle("Landsat NDVIs", subtitle = "NEON Harvard Forest") +
  theme_void()


#center the plot title and subtitles
#hjust = horizontal justification
ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))


# challenge: change the plot title to a bold font 
#   hint: part of the theme() function

ggplot() +
  geom_raster(data = NDVI_HARV_stack_df,
              aes(x = x, y = y, fill = value)) +
  facet_wrap(~ variable) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5))

# or:
ggplot() +
  geom_raster(data = NDVI_HARV_stack_df,
              aes(x = x, y = y, fill = value)) +
  facet_wrap(~ variable) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5))


#Adjusting the color ramp

# boo to blue 
# yellow green? makes more sense since its NDVI greenness maybe....

library(RColorBrewer)
brewer.pal(9, "YlGn")

green_colors <- brewer.pal(9, "YlGn") %>%
  colorRampPalette()

ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5)) + 
  scale_fill_gradientn(name = "NDVI", colours = green_colors(20))


# check out other pallettes:
# https://www.datavis.ca/sasmac/brewerpal.html



#Refine plot and tile labels
# remove _HARV_NDVI_crop from each label to make it shorter 
names(NDVI_HARV_stack)

# using gsub()
# replace HARV-NDVI-crop with blank ""
raster_names <- names(NDVI_HARV_stack)

raster_names <- gsub("_HARV_ndvi_crop", "", raster_names)
raster_names

# last time we added an X
# but because we cleared, and the lesson didn't, those x's are gone.
# so instead of gsub like in the lesson, 
# we use sub, add "" and "Day " 
raster_names  <- sub( "", "Day ", raster_names)
raster_names

# names look good. assign them
labels_names <- setNames(raster_names, unique(NDVI_HARV_stack_df$variable))

ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable, labeller = labeller(variable = labels_names)) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5)) + 
  scale_fill_gradientn(name = "NDVI", colours = green_colors(20))


#changing layout of panels
# ncol in facetwrap
ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable, ncol = 5, 
             labeller = labeller(variable = labels_names)) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5)) + 
  scale_fill_gradientn(name = "NDVI", colours = green_colors(20))

# Challenge Divergent Color Ramps

# label each tile 'julian day' with the julian day value following (use sub or gsub())
# change the color ramp to a divergent brown to green color ramp

raster_names  <- gsub("Day","Julian Day", raster_names)
raster_names
labels_names <- setNames(raster_names, unique(NDVI_HARV_stack_df$variable))

brown_green_colors <- colorRampPalette(brewer.pal(9, "BrBG"))


ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable, ncol = 5, labeller = labeller(variable = labels_names)) +
  ggtitle("Landsat NDVI - Julian Days", subtitle = "Harvard Forest 2011") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5)) +
  scale_fill_gradientn(name = "NDVI", colours = brown_green_colors(20))

# what do you think? Is it better?




