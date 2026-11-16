library(tidyverse)

data <- read_csv("data.csv")

# remove "other" row
data <- data %>% filter(association != "other")

data %>% 
  ggplot(aes(x = fct_reorder(association, desc(schools)), y = schools)) +
  geom_col(aes(fill = association)) +
  labs(
    title = "HMC Member Associations",
    x = "associations",
    y = "number of HMC member schools"
  ) +
  theme (
    plot.background = element_rect(fill = "black"),
    plot.title = element_text(face = "bold", colour = "white"),
    panel.background = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.title = element_text(colour = "white"),
    axis.text = element_text(colour = "white"),
    axis.ticks = element_blank(),
    legend.position = "none"
  )
