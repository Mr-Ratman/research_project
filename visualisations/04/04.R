library(tidyverse)

data <- read_csv("data.csv")

# data_longer is data used by geom_col - for the later date it shows only the increase on the stacked chart*/
data_longer <- data %>% 
  mutate(`2024-07` = `2024-07` - `2019-07`) %>% 
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "date", 
    values_to = "schools"
  )

# data_longer_text is data used by geom_text - it shows the total for each date
data_longer_text <- data %>% 
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "date", 
    values_to = "schools"
  )

data_longer %>% 
  ggplot(aes(x = schools, y = reorder(region, schools), fill = factor(date, levels = c("2024-07", "2019-07")))) +
  geom_col() +
  scale_fill_manual(
    breaks = c("2019-07", "2024-07"),
    values = c("black", "red"),
    labels = c("July 2019", "July 2024")
  ) +
  geom_text(
    aes(label = data_longer_text$schools, x = data_longer_text$schools), 
    hjust = rep(c(1, 0), times = nrow(data)),
    position = position_nudge(x = rep(c(-25, 25), times = nrow(data))),
    colour = rep(c("white", "black"), times = nrow(data))
  ) +
  labs(title = "Five Years of School Growth", y = "region") +  
  theme(
    plot.background = element_rect(fill = "grey92"),
    axis.line.x = element_line(color = "grey"),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "grey"),
    axis.text.y = element_text(color = "black", face = "bold"),
    legend.position = "bottom",
    legend.background = element_rect(fill = "grey92"),
    legend.title = element_blank()
  )
