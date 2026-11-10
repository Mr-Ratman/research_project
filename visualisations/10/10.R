library(tidyverse)
library(ggimage)
library(ggtext)

data <- read_csv("data.csv")

fill_colours <- c("red", "turquoise", "magenta", "dodgerblue")

# create markdown for x axis labels
x.label <- paste0("<span style = 'color: ", fill_colours, ";'>", data$category, "<br>SCHOOLS</span>")

# put labels in same order as data
x.label <- factor(x.label, levels = x.label)

data %>% 
  ggplot(aes(x.label, fees)) +
  geom_col(aes(fill = x.label)) +
  scale_fill_manual(values = fill_colours) + 
  geom_text(aes(label = paste0("US$", fees, "K")), vjust = 1.5, fontface = "bold") + 
  geom_image(
    aes(
      y = fees + 4,
      image = paste0(image, ".png")
    ),
    size = 0.2
  ) +
  ylim(0, 35) +
  labs(
    title = "Cost of British education abroad",
    subtitle = "average annual fees by international school type"
  ) +
  theme(
    plot.background = element_rect(fill = "grey92"),
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
