library(tidyverse)
library(maps)
library(ggrepel)

ISC_data <- read_csv("data.csv")

data <- inner_join(ISC_data, map_data("world"), by = "region")

# use distinct to just get the first row for each region (so each region has one set of long/lat coordinates)
data_top_regions <- distinct(inner_join(ISC_data, map_data("world"), by = "region"), region, .keep_all = TRUE)

data %>% ggplot(mapping = aes(x = long, y = lat, group = group)) + 
  geom_polygon(data = map_data("world"), fill = "white", colour = "grey50") + 
  coord_fixed(1.3) +
  geom_polygon(aes(fill = `schools`)) + 
  scale_fill_distiller(palette ="Blues", direction = 1, breaks = seq(0, 4)) +
  geom_label_repel(data = data_top_regions, aes(x = long, y = lat, label = paste0(region, " ", `schools`)), size = 3) +
  labs(title = "Future Locations of HMC Satellite Schools") +
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )
