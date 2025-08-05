# ep 14
# Deriving values from raster time series

# extracting pixels from rasters, saving summary values to a csv file 
# plotting pixel summary values using ggplot() 
# comparing NDVI values between two different sites 

library(pacman)
pacman::p_unload(pacman::p_loaded(), character.only = TRUE)

library(dplyr)
library(terra)
library(ggplot2)
library(tidyr)

rm(list=ls())
current_episode <- 14

# objects from last time
NDVI_HARV_path <- "data/NEON-DS-Landsat-NDVI/HARV/2011/NDVI"
all_NDVI_HARV <- list.files(NDVI_HARV_path,
                            full.names = TRUE,
                            pattern = ".tif$")

NDVI_HARV_stack <- rast(all_NDVI_HARV)
head(NDVI_HARV_stack)
NDVI_HARV_stack <- NDVI_HARV_stack / 10000
NDVI_HARV_stack
# episode starts here.

# take the average of all the pixels
# in each raster (note we are looking at the spatraster object, not the dataframe)
nlyr(NDVI_HARV_stack)
avg_NDVI_HARV <- global(NDVI_HARV_stack, mean)

avg_NDVI_HARV
head(avg_NDVI_HARV)


# change the column name
names(avg_NDVI_HARV) <- "meanNDVI"
head(avg_NDVI_HARV)

# add columns for site and year 
avg_NDVI_HARV$site <- "HARV"
avg_NDVI_HARV$year <- "2011"

#voila
head(avg_NDVI_HARV)

# Extract Julian Dates from row names 
# that's a 'bar' or a pipe. it is 'or'
# replace x OR '_HARV_ndvi_crop' with nothing
# gsub is 1st or all occurences.

# julianDays <- gsub("X|_HARV_ndvi_crop", "", row.names(avg_NDVI_HARV))

avg_NDVI_HARV
julianDays <- gsub("_HARV_ndvi_crop", "", row.names(avg_NDVI_HARV))


julianDays

avg_NDVI_HARV

# add julian days as a column
avg_NDVI_HARV$julianDay <- julianDays

# but it's text. we need dates.
class(avg_NDVI_HARV$julianDay)

# converting julian day to date class
# there's a NEON tutorial for this!

# what's the first day of the year?
origin <- as.Date("2011-01-01")
str(origin)

# convert julian day to integer
avg_NDVI_HARV$julianDay <- as.integer(avg_NDVI_HARV$julianDay)

# the -1 is to start counting on Jan 1 instead of Jan 0.
avg_NDVI_HARV$Date <- origin + (avg_NDVI_HARV$julianDay - 1)
head(avg_NDVI_HARV$Date)

class(avg_NDVI_HARV$Date)



# challenge: NDVI for SJER/San Joaquin 
# will compare the two sites later

# Create a dataframe containing the mean NDVI values 
# and the Julian days that the data was collected (in date format) 
# for the NEON San Joaquin Experimental Range field site. 
# NDVI data for SJER are located in the NEON-DS-Landsat-NDVI/SJER/2011/NDVI directory.

# here's the first part:
NDVI_path_SJER <- "data/NEON-DS-Landsat-NDVI/SJER/2011/NDVI"

all_NDVI_SJER <- list.files(NDVI_path_SJER,
                            full.names = TRUE,
                            pattern = ".tif$")

# make a stack
NDVI_stack_SJER <- rast(all_NDVI_SJER)
nlyr(NDVI_stack_SJER)

# check the values
summary(NDVI_stack_SJER)

# do we need a scale factor?
NDVI_stack_SJER <- NDVI_stack_SJER/10000

# calculate the means
SJER_mean_NDVI <- global(NDVI_stack_SJER, mean)

str(SJER_mean_NDVI)

# add columns
names(SJER_mean_NDVI) <- "NDVImean"
str(SJER_mean_NDVI)

SJER_mean_NDVI$site <- "SJER"
SJER_mean_NDVI$year <- "2011"


# handle the dates

julianDays_SJER <- gsub("_SJER_ndvi_crop", "", row.names(avg_NDVI_SJER))
julianDays_SJER

origin <- as.Date("2011-01-01")
avg_NDVI_SJER$julianDay <- as.integer(julianDays_SJER)

avg_NDVI_SJER$Date <- origin + (avg_NDVI_SJER$julianDay - 1)

head(avg_NDVI_SJER)
str(avg_NDVI_SJER)


# plot NDVI using ggplot

ggplot(avg_NDVI_HARV, aes(julianDay, meanNDVI)) +
  geom_point() +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "NEON Harvard Forest Field Site") +
  xlab("Julian Days") + ylab("Mean NDVI")




# challenge ################
# plot SJER/San Joaquin 
# don't use black

ggplot(avg_NDVI_SJER, aes(julianDay, meanNDVI)) +
  geom_point(colour = "SpringGreen4") +
  ggtitle("Landsat Derived NDVI - 2011", subtitle = "NEON SJER Field Site") +
  xlab("Julian Day") + ylab("Mean NDVI")





#comparing the NDVI of two sites on one plot 

# use rbind to merge the SJER and HARV datasets together
# same # of columns with same column names 
NDVI_HARV_SJER <- rbind(avg_NDVI_HARV, avg_NDVI_SJER)

str(NDVI_HARV_SJER)
summary(NDVI_HARV_SJER)

ggplot(NDVI_HARV_SJER, aes(x = julianDay, y = meanNDVI, colour = site)) +
  geom_point(aes(group = site)) +
  geom_line(aes(group = site)) +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "Harvard Forest vs San Joaquin") +
  xlab("Julian Day") + ylab("Mean NDVI")

str(NDVI_HARV_SJER)

# I dont like julian days, can I get it like a normal person?
ggplot(NDVI_HARV_SJER, aes(x = Date, y = meanNDVI, colour = site)) +
  geom_point(aes(group = site)) +
  geom_line(aes(group = site)) +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "Harvard Forest vs San Joaquin") +
  xlab("Date") + ylab("Mean NDVI")

#removing outlier data
avg_NDVI_HARV_clean <- subset(avg_NDVI_HARV, meanNDVI > 0.1)
avg_NDVI_HARV_clean$meanNDVI < 0.1

avg_NDVI_HARV$meanNDVI < 0.1


ggplot(avg_NDVI_HARV_clean, aes(x = julianDay, y = meanNDVI)) +
  geom_point() +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "NEON Harvard Forest Field Site") +
  xlab("Julian Days") + ylab("Mean NDVI")
head(avg_NDVI_HARV_clean)


# final challenge:
# remove outliers from SJER
# and recreate the plot of both of them.
str(SJER_mean_NDVI)
avg_NDVI_SJER
avg_NDVI_SJER_clean <- subset(avg_NDVI_SJER, meanNDVI > 0.1)

avg_NDVI_SJER_clean$meanNDVI < 0.1

names(avg_NDVI_HARV_clean)
names(avg_NDVI_SJER_clean)


NDVI_HARV_SJER <- rbind(avg_NDVI_HARV_clean, avg_NDVI_SJER_clean)

NDVI_HARV_SJER

ggplot(NDVI_HARV_SJER, aes(x = Date, y = meanNDVI, colour = site)) +
  geom_point(aes(group = site)) +
  geom_line(aes(group = site)) +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "Harvard Forest vs San Joaquin") +
  xlab("Date") + ylab("Mean NDVI")




