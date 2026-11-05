library(tidyverse)

data <- read_csv("data.csv")

# waffle chart

library(waffle)

data %>% 
  ggplot(aes(fill = region, values = share)) +
  geom_waffle(n_rows = 10, colour = "white") +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "black"),
    plot.margin = unit(c(5, 5, 5, 5), "mm"),
    plot.title = element_text(colour = "white", hjust = 0.5),
    legend.title = element_text(colour = "white"),
    legend.text = element_text(colour = "white")
  ) +
  labs(title = "Global Market by Regions") +
  scale_fill_discrete(
    breaks = data$region,
    labels = paste0(data$region, " ", data$share, "%")
  )

# treemap

library(treemapify)

data %>% 
  ggplot(aes(area = share, fill = continent, label = continent, subgroup = region)) +
  geom_treemap() +
  geom_treemap_subgroup_border(size = 1) +
  geom_treemap_subgroup_text(place = "bottom", colour = "black", size = 9, min.size = 0, reflow = TRUE, aes(subgroup = paste0(data$region, " ", data$share, "%"))) +
  geom_treemap_text(place = "top", colour = "white", size = 11) +
  theme(legend.position = "none")
