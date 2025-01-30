# episode 7
rm(list=ls())

library(terra)
library(dplyr)
library(ggplot2)
library(sf)

# objects from previous lesson
point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")
lines_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARV_roads.shp")

point_HARV

ncol(lines_HARV)
names(lines_HARV)
head(lines_HARV)
str(lines_HARV)

# challenge goes here


# Explore values
lines_HARV$TYPE
str(lines_HARV$TYPE)

unique(lines_HARV$TYPE)

footpath_HARV <- lines_HARV %>%
  filter(TYPE == "footpath")
nrow(footpath_HARV)

ggplot() +
  geom_sf(data = footpath_HARV) +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Footpaths") +
  coord_sf()

# make them color and on the legend
ggplot() +
  geom_sf(data = footpath_HARV, aes(color = factor(OBJECTID)), size = 1.5) +
  labs(color = 'Footpath ID') +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Footpaths using color") +
  coord_sf()


# challenge: subset lines
boardwalk_HARV <- lines_HARV %>%
  filter(TYPE == "boardwalk")

nrow(boardwalk_HARV)

ggplot() +
  geom_sf(data = boardwalk_HARV, size = 1.5) +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Boardwalks") +
  coord_sf()

# challenge pt 2
stoneWall_HARV <- lines_HARV %>%
  filter(TYPE == "stone wall")
nrow(stoneWall_HARV)

ggplot() +
  geom_sf(data = stoneWall_HARV, aes(color = factor(OBJECTID)), size = 1.5) +
  labs(color = 'Wall ID') +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Stonewalls") +
  coord_sf()

road_colors <- c("blue", "green", "navy", "purple")

ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE)) +
  scale_color_manual(values = road_colors) +
  labs(color = 'Road Type') +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Roads & Trails") +
  coord_sf()

line_widths <- c(1, 2, 3, 4)

ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE, linewidth = TYPE)) +
  scale_color_manual(values = road_colors) +
  labs(color = 'Road Type') +
  scale_size_manual(values = line_widths) +
  ggtitle("NEON Harvard Forest Field Site",
          subtitle = "Roads & Trails - Line width varies") +
  coord_sf()

# challenge: specify widths
unique(lines_HARV$TYPE)

line_width <- c(1, 3, 2, 6)

# this one is wrong
ggplot() +
  geom_sf(data = lines_HARV, aes(size = TYPE)) +
  scale_size_manual(values = line_width) +
  ggtitle("NEON Harvard Forest Field Site",
          subtitle = "Roads & Trails - Line width varies") +
  coord_sf()

# this one is correct
ggplot() +
  geom_sf(data = lines_HARV, aes(linewidth = TYPE)) +
  scale_size_manual(values = line_width) +
  ggtitle("NEON Harvard Forest Field Site",
          subtitle = "Roads & Trails - Line width varies") +
  coord_sf()

# customize legend
# (linewidth not size)
ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE), linewidth = 1.5) +
  scale_color_manual(values = road_colors) +
  labs(color = 'Road Type') +
  ggtitle("NEON Harvard Forest Field Site",
          subtitle = "Roads & Trails - Default Legend") +
  coord_sf()

ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE), linewidth = 3.5) +
  scale_color_manual(values = road_colors) +
  labs(color = 'Road Type') +
  theme(legend.text = element_text(size = 20),
        legend.box.background = element_rect(linewidth = 3)) +
  ggtitle("NEON Harvard Forest Field Site",
          subtitle = "Roads & Trails - Modified Legend") +
  coord_sf()

