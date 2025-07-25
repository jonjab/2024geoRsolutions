#ep 12
# raster times series data 

#import NDVI data in geotiff format
#import, explore, and plot NDVI data derived for several dates through the year
#view RGB imagery used to derive NDVI time series 

rm(list=ls())
current_episode <- 12

library(terra)
library(ggplot2)

# this might be the first time we are using tidyr
library(tidyr)
library(scales)
# library(dplyr)
# install.packages("tidyr","scales") if not installed 

# RGB data
# Getting Started
NDVI_HARV_path <- "data/NEON-DS-Landsat-NDVI/HARV/2011/NDVI"
NDVI_HARV_path

# 'paste' the path to the filenames
all_NDVI_HARV <- list.files(NDVI_HARV_path,
                            full.names = TRUE,
                            pattern = ".tif$")

# look at those file names
# these are in 'Julian days.' the day of the year
all_NDVI_HARV

# create raster stack
NDVI_HARV_stack <- rast(all_NDVI_HARV)

# check crs
crs(NDVI_HARV_stack, proj = TRUE)
crs(NDVI_HARV_stack)

# Challenge: Raster Metadata 
#what are the x,y resolution? 
#what units are the above resolution in?


ext(NDVI_HARV_stack)
yres(NDVI_HARV_stack)
xres(NDVI_HARV_stack)

# these are small. Don't be surprised.
dim(NDVI_HARV_stack)

# y'all will get used to seeing 30m data
# because that's Landsat.


# Plotting time series data 

# as.data.frame time.
# use pivot longer to clean up data so there is a single column with NDVI obs
# this also enable the facer_wrap 

NDVI_HARV_stack_df <- as.data.frame(NDVI_HARV_stack, xy = TRUE) %>%
  pivot_longer(-(x:y), names_to = "variable", values_to = "value")

ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~ variable)

# help says facet_grid is another option, but it's ugly:
ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_grid(~ variable)

summary(NDVI_HARV_stack_df$value)

#scale factors
#there is a specific scale factor with this data: 10K

# used to maintain smaller file sizes by removing floats?
# integer math is faster. integer objects are smaller

NDVI_HARV_stack <- NDVI_HARV_stack/10000

NDVI_HARV_stack_df <- as.data.frame(NDVI_HARV_stack, xy = TRUE) %>%
  pivot_longer(-(x:y), names_to = "variable", values_to = "value")

ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable)


#view distribution of raster values
ggplot(NDVI_HARV_stack_df) +
  geom_histogram(aes(value)) + 
  facet_wrap(~variable)
# everything is within a pattern, except for days 277 and 293. 


#Explore unusual data patterns

# let's look at the weather to see those days.
# this is a red herring and a complete aside!!!
har_met_daily <-
  read.csv("data/NEON-DS-Met-Time-Series/HARV/FisherTower-Met/hf001-06-daily-m.csv")

# we have jd AND yyy-mm-dd columns.
# jd's are integers. yyy.mm.dd is text.
str(har_met_daily)
colnames(har_met_daily)

#format the text dates to date-dates to YYYY-MM-DD
har_met_daily$date <- as.Date(har_met_daily$date, format = "%Y-%m-%d")

#to only view 2011 (or any specific year)
yr_11_daily_avg <- har_met_daily %>%
  filter(between(date, as.Date('2011-01-01'), as.Date('2011-12-31')))

#plot air temp by julian day (jd column):
ggplot() +
  geom_point(data = yr_11_daily_avg, aes(jd, airt)) +
  ggtitle("Daily Mean Air Temperature",
          subtitle = "NEON Harvard Forest Field Site") +
  xlab("Julian Day 2011") +
  ylab("Mean Air Temperature (C)")



#Challenge: Examine RGB raster files 
#plot RGB images for Julian Days 277 and 293
#compare with Julian Days 133 and 197

RGB_277 <- rast("data/NEON-DS-Landsat-NDVI/HARV/2011/RGB/277_HARV_landRGB.tif")
# you'll see that the RGBs also have julian days.


# NOTE: Fix the bands' names so they don't start with a number!
names(RGB_277) <- paste0("X", names(RGB_277))

RGB_277

#fix to values within 0-1
RGB_277 <- RGB_277/255

RGB_277_df <- as.data.frame(RGB_277, xy = TRUE)
str(RGB_277_df)

# calculate an rgb value for each pixel
# and store that as a hexdec color

# this feels so hacky, but it is a way to plot an 
# rgb raster with ggplot2
# gemini says this gives lots of control over the color pallette.

# we haven't seen 'with' in this workshop.
RGB_277_df$rgb <- 
  with(RGB_277_df, rgb(X277_HARV_landRGB_1, X277_HARV_landRGB_2, 
                       X277_HARV_landRGB_3, 1))

# we might learn about rgb() in ep 13 when we also talk about color schemes.

str(RGB_277_df)

#plot RGB data for JD 277
ggplot() +
  geom_raster(data=RGB_277_df, aes(x, y), fill=RGB_277_df$rgb) + 
  ggtitle("Julian day 277") 


# Julian day 293
# clouds will mess up any NDVI. No vegetation!
RGB_293 <- rast("data/NEON-DS-Landsat-NDVI/HARV/2011/RGB/293_HARV_landRGB.tif")
names(RGB_293) <- paste0("X", names(RGB_293))
RGB_293 <- RGB_293/255
RGB_293_df <- as.data.frame(RGB_293, xy = TRUE)
RGB_293_df$rgb <- 
  with(RGB_293_df, rgb(X293_HARV_landRGB_1, X293_HARV_landRGB_2, 
                       X293_HARV_landRGB_3,1))

ggplot() +
  geom_raster(data = RGB_293_df, aes(x, y), fill = RGB_293_df$rgb) +
  ggtitle("Julian day 293")



# Julian day 133
RGB_133 <- rast("data/NEON-DS-Landsat-NDVI/HARV/2011/RGB/133_HARV_landRGB.tif")
names(RGB_133) <- paste0("X", names(RGB_133))
RGB_133 <- RGB_133/255
RGB_133_df <- as.data.frame(RGB_133, xy = TRUE)
RGB_133_df$rgb <- 
  with(RGB_133_df, rgb(X133_HARV_landRGB_1, X133_HARV_landRGB_2, 
                       X133_HARV_landRGB_3, 1))
ggplot() +
  geom_raster(data = RGB_133_df, aes(x, y), fill = RGB_133_df$rgb) +
  ggtitle("Julian day 133")


# or without all the ggplot:
RGB_133 <- rast("data/NEON-DS-Landsat-NDVI/HARV/2011/RGB/133_HARV_landRGB.tif")
names(RGB_133) <- paste0("X", names(RGB_133))
RGB_133 <- RGB_133/255

plotRGB(RGB_133, r=1, g=2, b=3, stretch="lin")    

