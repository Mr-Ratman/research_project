library(tidyverse)

data <- read_csv("data.csv")

categories = c("1", "2-4", "5-10", "11+")

data$category <- cut(data$schools, breaks = c(0, 1, 4, 10, Inf), labels = categories)

label_data <- data %>% 
  group_by(category) %>% 
  arrange(brand) %>% 
  # paste the brand names together, separated by a newline character*/
  summarize(count = n(), brands = paste(brand, collapse = "\n"))

data %>%
  ggplot(aes(category)) +
  geom_bar(aes(fill = category)) +
  scale_fill_manual(values = c("grey", "mediumaquamarine", "lightsalmon", "lightpink")) +
  geom_label(
    data = label_data,
    aes(
      x = category,
      y = count,
      label = paste0(
        count,
        " brands with\n",
        category,
        ifelse(category == "1", " school", " schools")
      )
    ),
    vjust = -0.25
  ) +
  geom_text(
    data = label_data,
    aes(
      x = category,
      y = count,
      label = brands
    ),
    vjust = 1.1,
    size = 3
  ) +
  labs(
    title = "Number of Satellite Schools per Brand",
    x = "number of satellite schools",
    y = "number of brands"
  ) +
  theme(
    legend.position = "none"
  ) +
  # set the y axis limits to there's room for the labels
  coord_cartesian(ylim = c(0, 25))
