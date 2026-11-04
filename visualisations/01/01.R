library(tidyverse)

data <- read_csv("data.csv")

fill_colours <- c("red", "magenta", "dodgerblue", "turquoise")

ggplot(data) +
  geom_col(aes(
    reorder(category, datapoints),
    datapoints,
    fill = factor(rank(datapoints)))
  ) +
  scale_fill_manual(values = fill_colours) +
  geom_text(aes(
    category,
    -5000,
    label = scales::comma(datapoints),
    colour = factor(rank(datapoints))
  ), size = 6, fontface = "bold", vjust = 1) +
  geom_text(aes(
    category,
    -35000,
    label = paste("DATAPOINTS ON\n", toupper(category)),
    colour = factor(rank(datapoints)),
  ), size = 3, fontface = "bold", vjust = 1) +
  scale_colour_manual(values = fill_colours) +
  labs(title = "ISC Datapoints") +
  theme(
    plot.margin = margin(b = 25),
    panel.heights = unit(25, "mm"),
    plot.background = element_rect(fill = "black"),
    plot.title = element_text(colour = "white", hjust = 0.5, vjust = 0),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none",
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_blank()
  ) +
  coord_cartesian(clip = "off")
