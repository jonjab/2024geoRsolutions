# ep 5
# color

rm(list=ls())
current_episode <- 5

library(terra)
library(ggplot2)
library(dplyr)

RGB_band1_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", lyr=1)
plot(RGB_band1_HARV)

RGB_stack_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")
plotRGB(RGB_stack_HARV, r=1, g=2, b=3)

plotRGB(RGB_stack_HARV, r=1, g=2, b=3,
        stretch="lin")

plotRGB(RGB_stack_HARV, r=1, g=2, b=3,
        stretch="hist")


methods(class=class(RGB_stack_HARV))
