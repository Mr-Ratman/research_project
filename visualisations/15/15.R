library(tidyverse)
library(maps)
library(ggrepel)

ISC_data <- read_csv("data.csv")

# filter out any regions that have a subregion - this will exclude Hong Kong
data_regions <- inner_join(filter(ISC_data, is.na(subregion)), map_data("world"), by = "region")

# include any regions that have a subregion - this will include Hong Kong
data_subregions <- inner_join(filter(ISC_data, !is.na(subregion)), map_data("world"), by = "subregion")

# labels will include any regions with more than 2 HMC schools
# use distinct to just get the first row for each region (so each region has one set of long/lat coordinates)
data_top_regions <- distinct(inner_join(filter(ISC_data, `HMC schools` > 2), map_data("world"), by = "region"), region, .keep_all = TRUE)

data_regions %>% ggplot(mapping = aes(x = long, y = lat, group = group)) + 
  geom_polygon(data = map_data("world"), fill = "white", colour = "grey50") + 
  coord_fixed(1.3) +
  geom_polygon(aes(fill = `HMC schools`)) +
  # this maps Hong Kong - it's not really easy to see anyway!
  geom_polygon(data = data_subregions, aes(fill = `HMC schools`)) +
  scale_fill_distiller(palette = "Blues", direction = 1, breaks = seq(0, 10, 2)) +
  geom_label_repel(data = data_top_regions, aes(x = long, y = lat, label = paste0(region, " ", `HMC schools`)), size = 3) +
  labs(title = "Global Split of HMC Member Schools") +
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )
