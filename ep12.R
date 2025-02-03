# episode 12
# NDVI

rm(list=ls())

library(sf)
library(terra)
library(ggplot2)
library(dplyr)
library(tidyr)
# library(scales)

NDVI_HARV_path <- ("data/NEON-DS-Landsat-NDVI/HARV/2011/NDVI")

all_NDVI_HARV <- list.files(NDVI_HARV_path,
                            full.names = TRUE,
                            pattern = ".tif$")
all_NDVI_HARV

NDVI_HARV_stack <- rast(all_NDVI_HARV)

summary(NDVI_HARV_stack)
res(NDVI_HARV_stack)

# to work on these as a dataframe, you'll also want to pivot_longer

NDVI_HARV_stack_df <- as.data.frame(NDVI_HARV_stack, xy=TRUE) %>% 
  # (but don't make x and y longer)
  pivot_longer(-(x:y), names_to = "variable", values_to ="value")

str(NDVI_HARV_stack_df)

ggplot() +
  geom_raster(data=NDVI_HARV_stack_df, aes(x=x, y=y, fill=value)) +
  facet_wrap(~variable)

NDVI_HARV_stack <- NDVI_HARV_stack/10000

NDVI_HARV_stack_df <- as.data.frame(NDVI_HARV_stack, xy=TRUE) %>% 
  # (but don't make x and y longer)
  pivot_longer(-(x:y), names_to = "variable", values_to ="value")

ggplot() +
  geom_raster(data=NDVI_HARV_stack_df, aes(x=x, y=y, fill=value)) +
  facet_wrap(~variable)

# let's look at the weather.

har_met_daily <- read.csv("data/NEON-DS-Met-Time-Series/HARV/FisherTower-Met/hf001-06-daily-m.csv")
str(har_met_daily)
colnames(har_met_daily)


har_met_daily$date <- as.Date(har_met_daily$date, format = "%Y-%m-%d")

yr_11_daily_avg <- har_met_daily %>%
  filter(between(date, as.Date('2011-01-01'), as.Date('2011-12-31')))

ggplot() +
  geom_point(data = yr_11_daily_avg, aes(jd, airt)) +
  ggtitle("Daily Mean Air Temperature",
          subtitle = "NEON Harvard Forest Field Site") +
  xlab("Julian Day 2011") +
  ylab("Mean Air Temperature (C)")






RGB_277 <- rast("data/NEON-DS-Landsat-NDVI/HARV/2011/RGB/277_HARV_landRGB.tif")

# NOTE: Fix the bands' names so they don't start with a number!
names(RGB_277) <- paste0("X", names(RGB_277))

RGB_277
RGB_277 <- RGB_277/255
RGB_277_df <- as.data.frame(RGB_277, xy = TRUE)

RGB_277_df$rgb <- 
  with(RGB_277_df, rgb(X277_HARV_landRGB_1, X277_HARV_landRGB_2, 
                       X277_HARV_landRGB_3, 1))



ggplot() +
  geom_raster(data=RGB_277_df, aes(x, y), fill=RGB_277_df$rgb) + 
  ggtitle("Julian day 277") 



# episode 13 starts
library(RColorBrewer)
ggplot() +
  geom_raster(data=NDVI_HARV_stack_df, aes(x=x, y=y, fill=value)) +
  facet_wrap(~variable)+
  ggtitle("Landsat NDVIs")+
    theme_void()

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
