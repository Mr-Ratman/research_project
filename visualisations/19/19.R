library(tidyverse)

data <- read_csv("data.csv")

df <- expand.grid(x = 1:10, y = 1:10)

category <- rev(rep(data$type, data$share))

for (i in 0:4) {
  category[(i * 20 + 1):(i * 20 + 10)] <- rev(category[(i * 20 + 1):(i * 20 + 10)])
}

df$category <- category

df %>% 
  ggplot(aes(x = x, y = y, fill = category)) +
  geom_tile(color = "white") +
  labs(title = "HMC Member Boarding Options") + 
  scale_fill_discrete(
    breaks = data$type,
    labels = paste0(data$type, " ", data$share, "%"),
    type = c("aquamarine", "blue", "magenta")
  ) +
  theme(
    plot.background = element_rect(fill = "black"),
    plot.title = element_text(colour = "white"),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    legend.background = element_blank(),
    legend.title = element_blank(),
    legend.text = element_text(colour = "white")
  )
