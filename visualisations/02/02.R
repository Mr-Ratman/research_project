library(tidyverse)
library(ggimage)
library(ggpubr)

data <- read_csv("/Users/paul/Desktop/research project/graph PDF01P05/data.csv")

fill_colours <- c("red", "magenta", "dodgerblue", "turquoise")

# put data in graph friendly longer format
data_longer <- data %>% 
  pivot_longer(
    cols = !category,
    names_to = "time",
    values_to = "value"
  )

categories <- data_longer %>% 
  distinct(category)

# increases will save percentage increase for each category
increases <- vector()

# graphs is list of graphs to pass to ggarrange
graphs <- list()

# loop through categories
for (i in 1:length(categories$category)) {
  # min is minimum value for this category
  min <- data_longer %>% filter(category == categories$category[i]) %>% select(value) %>% min()
  
  # max is maximum value for this category
  max <- data_longer %>% filter(category == categories$category[i]) %>% select(value) %>% max()
  
  # calculate percentage increase for this category
  increases[i] <- round(((max / min) - 1) * 100)
  
  graphs[[i]] <- data_longer %>% 
    filter(category == categories$category[i]) %>% 
    ggplot(aes(value, time)) +
    geom_col(fill = fill_colours[i]) +
    geom_text(aes(label = scales::comma(value)), hjust = 1.1) + # hjust moves value label to left
    geom_image(
      data = tibble(value = max, time = "before"), # create data table with position of image
      # !! is injection operator - forces evaluation of image path
      # without !! evaluation happens at end and image is always last image
      aes(image = !!paste0("/Users/paul/Desktop/research project/graph PDF01P05/", categories$category[i], ".png")),
      size = 0.5
    ) +
    theme(
      plot.background = element_rect(fill = "black", colour="black"), #colour is border - without this it's white
      plot.title = element_text(face = "bold", colour = fill_colours[i]),
      panel.background = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = "none",
      axis.title = element_blank(),
      axis.ticks = element_blank(),
      axis.text.y = element_blank(),
      axis.text.x = element_blank()
    ) + 
    labs(title = paste0(str_to_upper(categories$category[i]), " - GROWTH ", increases[i], "%"))
}

ggarrange(plotlist = graphs, ncol = 1)

# I had a go at using facet_wrap and scales = "free" > I think a loop with ggarrange is better
# everything seemed possible except the colour of the facet titles
# I didn't add images
# I hard coded the values for increase - I'd need to generate these from the data

#make sure facets are in same order as data, and edit the labels
data_longer$category = factor(data_longer$category, levels = distinct(data_longer, category)$category, labels = paste0(str_to_upper(distinct(data_longer, category)$category), " - GROWTH ", c(10, 14, 15, 23), "%"))

data_longer %>% 
  ggplot(aes(value, time)) +
  geom_col(aes(fill = category)) +
  scale_fill_discrete(type = fill_colours) +
  geom_text(aes(label = scales::comma(value)), hjust = 1.1) +
  facet_wrap( ~ category, ncol = 1, scales = "free") +
  theme(
    plot.background = element_rect(fill = "black"),
    panel.background = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0, colour = "white"),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )
