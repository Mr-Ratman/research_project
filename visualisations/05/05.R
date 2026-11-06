library(tidyverse)

data <- read_csv("data.csv")

data_longer <- data %>% 
  pivot_longer(
    cols = c(2, 3, 4), 
    names_to = "category", 
    values_to = "schools"
  )

data_longer %>% 
  ggplot(aes(x = schools, y = reorder(region, schools), fill = category)) +
  geom_col(position = "dodge", stat = "identity") +
  scale_fill_discrete(
    breaks = c("Premium", "Mid-market", "All"),
    type = c("red", "blue", "magenta")
  ) +
  labs(title = "Recently Founded International Schools") + 
  theme(
    plot.background = element_rect(fill = "grey92"),
    axis.line.x = element_line(color = "grey"),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "grey"),
    axis.title.y = element_blank(),
    axis.text.y = element_text(size = 10, color = "black", face = "bold"),
    legend.position = "top",
    legend.background = element_rect(fill = "grey92"),
    legend.title = element_blank()
  )
