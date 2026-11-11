library(tidyverse)

data <- read_csv("data.csv")

df <- expand.grid(x = 1:10, y = 1:10)

# add the regions to a vector - each region is added "share" times e.g. Europe is added 20 times
# the regions are added to the chart from the bottom - reverse the order so they match the legend
category <- rev(rep(data$group, data$share))

# reverse every second row so the colours stay in groups
for (i in 0:4) {
  category[(i * 20 + 1):(i * 20 + 10)] <- rev(category[(i * 20 + 1):(i * 20 + 10)])
}

df$category <- category

df %>% 
  ggplot(aes(x = x, y = y, fill = category)) +
  geom_tile(color = "black") +
  labs(title = "Groups Opening Future Schools") + 
  scale_fill_discrete(
    breaks = data$group,
    labels = paste0(data$group, " ", data$share, "%")
  ) +
  theme(
    plot.background = element_rect(fill = "grey92"),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    legend.background = element_blank(),
    legend.title = element_blank()
  )
