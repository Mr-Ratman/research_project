library(tidyverse)

data <- read_csv("data.csv")

# this creates a dataframe where each row is the coordinates of a tile on the grid
df <- expand.grid(x = 1:10, y = 1:10)

# add the regions to a vector - each region is added "share" times e.g. Europe is added 20 times
# the regions are added to the chart from the bottom - reverse the order so they match the legend
category <- rev(rep(data$region, data$share))

# reverse every second row so the colours stay in groups
for (i in 0:4) {
  category[(i * 20 + 1):(i * 20 + 10)] <- rev(category[(i * 20 + 1):(i * 20 + 10)])
}

df$category <- category

df %>% 
  ggplot(aes(x = x, y = y, fill = category)) +
  geom_tile(color = "black") +
  labs(title = "Future Schools Regional Breakdown") + 
  scale_fill_discrete(
    breaks = data$category,
    labels = paste0(data$region, " ", data$share, "%")
  ) +
  theme(
    panel.background = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    legend.title = element_blank()
  )
