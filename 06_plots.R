library(scales)
source(here::here("scripts", "05_small_data.R"))

# Draws 
span = as.data.frame(span_model) %>% 
  slice(1:300)

eng = as.data.frame(eng_model) %>% 
  slice(1:300)

# Scatter plots

ggplot(eng_data, aes(x = duration_z, 
                     y = log_freq_z, 
                     color = length_z)) +
  geom_point(size = 2, shape = 20) +
  scale_colour_gradient(low = "orange", high = muted("orange")) +
  xlab("Duration Z-score") + ylab("Log Frequency Z score") +
  theme_bw() +
  theme(panel.background = element_rect(fill = "grey79"),
        legend.position = "bottom") + 
  xlim(-2, 2) + ylim(-2, 2) +
  ggtitle("English Frequency Effect") +
  geom_abline(intercept = span$b_Intercept, 
              slope = span$b_log_freq_z,
              color = "white", size = 1.5, alpha = .05) +
  geom_abline(intercept = fixef(eng_model)[1, 1],
                slope =  fixef(eng_model)[2, 1], 
                color = "darkred", size = 1.5, alpha = .5) + 
  ggsave(here("slides", "img", "eng.png"))


ggplot(span_data, aes(x = duration_z, 
                      y = log_freq_z, 
                      color = length_z)) +
  geom_point(size = 2, shape = 20) +
  scale_colour_gradient(low = "cyan", high = muted("cyan")) +
  xlab("Duration Z-score") + ylab("Log Frequency Z score") +
  theme_bw() +
  theme(panel.background = element_rect(fill = "grey79"),
        legend.position = "bottom") + 
  xlim(-2, 2) + ylim(-2, 2) +
  ggtitle("Spanish Frequency Effect") + 
  geom_abline(intercept = span$b_Intercept, 
              slope = span$b_log_freq_z,
              color = "white", size = 1.5, alpha = .1) +
  geom_abline(intercept = fixef(span_model)[1, 1],
              slope =  fixef(span_model)[2, 1], 
              color = "darkred", size = 1.5, alpha = .5) + 
  ggsave(here("slides", "img", "span.png"))


# Forest Plots

span_posterior <- as.matrix(span_model)

plot_title_span <- ggtitle("Spanish Model Posterior distributions",
                      "with medians and 80% intervals")
mcmc_areas(span_posterior,
           pars = c("b_log_freq_z", "b_rate_z", "b_length_z"),
           prob = 0.8) + plot_title_span + xlim(-.7, .7) + 
  ggsave(here("slides", "img", "span_forest.png"))



eng_posterior <- as.matrix(eng_model)

plot_title_eng <- ggtitle("English Model Posterior distributions",
                           "with medians and 80% intervals")
mcmc_areas(eng_posterior,
           pars = c("b_log_freq_z", "b_rate_z", "b_length_z"),
           prob = 0.8) + plot_title_eng + xlim(-.7, .7) +
  ggsave(here("slides", "img", "eng_forest.png"))
