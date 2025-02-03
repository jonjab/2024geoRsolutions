# Day 3 review

rm(list=ls())

library(sf)
library(terra)
library(ggplot2)
library(dplyr)
library(calecotopo)

# lesson 7

state_boundary_US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-State-Boundaries-Census-2014.shp") %>% 
  st_zm()

class(state_boundary_US$region)
state_boundary_US$region <- as.factor(state_boundary_US$region)

colors <- c("purple", "springgreen", "yellow", "brown", "navy")

ggplot() +
  geom_sf(data=state_boundary_US, aes(color=region), linewidth = 1) +
  scale_color_manual(values = colors) +
  ggtitle("US States")
    coord_sf()
