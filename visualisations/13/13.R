library(tidyverse)
library(scales)

data <- read_csv("data.csv")

fill_colours <- c("red", "magenta", "dodgerblue", "turquoise")

# create markdown for x axis labels
x.label <- paste0(
  "<span style = 'color: ", fill_colours, "; font-size: 20px;'>", comma(data$datapoints), "</span><br>",
  "<span style = 'color: ", fill_colours, ";'>ON ", str_to_upper(data$category), "</span>"
)

# put labels in same order as data
x.label <- factor(x.label, levels = x.label)

data %>% 
  ggplot(aes(x.label, datapoints)) +
  geom_col(aes(fill = x.label)) +
  scale_fill_manual(values = fill_colours) +
  labs(title = "ISC Research Datapoints") +
  theme(
    plot.background = element_rect(fill = "black"),
    plot.title = element_text(face = "bold", colour = "red"),
    panel.heights = unit(30, "mm"),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none",
    axis.title = element_blank(),
    axis.text.x = element_markdown(face = "bold"),
    axis.text.y = element_blank(),
    axis.ticks = element_blank()
  )
  
