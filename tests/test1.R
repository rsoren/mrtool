#
# test1.R
#
# Reed Sorensen
# February 2021
#

library(dplyr)
# library(mrbrt001, lib.loc = "/ihme/code/mscm/R/packages/") # for R version 3.6.3

set.seed(1)
k_studies <- 10
n_per_study <- 5
# k_studies <- 40
# n_per_study <- 40
tau_1 <- 4
sigma_1 <- 1
tau_2 <- 0.6
sigma_2 <- 0.2

df_sim_study <- data.frame(study_id = as.factor(1:k_studies)) %>%
  mutate(
    study_effect1 = rnorm(n = k_studies, mean = 0, sd = tau_1),
    study_effect2 = rnorm(n = k_studies, mean = 0, sd = tau_2)
    # study_colors = brewer.pal(n = k_studies, "Spectral")
  )

df_sim1 <- do.call("rbind", lapply(1:nrow(df_sim_study), function(i) {
  df_sim_study[rep(i, n_per_study), ] })) %>%
  mutate(
    x1 = runif(n = nrow(.), min = 0, max = 10),
    y1 = 0.9*x1 + study_effect1 + rnorm(nrow(.), mean = 0, sd = sigma_1),
    y1_se = sigma_1,
    y2_true = 2 * sin(0.43*x1-2.9),
    y2 = y2_true - min(y2_true) + study_effect2 + rnorm(nrow(.), mean = 0, sd = sigma_2),
    y2_se = sigma_2,
    is_outlier = FALSE) %>%
  arrange(x1)

df_sim2 <- df_sim1 %>%
  rbind(., .[(nrow(.)-7):(nrow(.)-4), ] %>% mutate(y1=y1-18, y2=y2-4, is_outlier = TRUE))

# function for plotting uncertainty intervals
add_ui <- function(dat, x_var, lo_var, hi_var, color = "darkblue", opacity = 0.2) {
  polygon(
    x = c(dat[, x_var], rev(dat[, x_var])),
    y = c(dat[, lo_var], rev(dat[, hi_var])),
    col = adjustcolor(col = color, alpha.f = opacity), border = FALSE
  )
}
dat1 <- MRData()
dat1$load_df(
  data = df_sim1,  col_obs = "y1", col_obs_se = "y1_se",
  col_covs = list("x1"), col_study_id = "study_id" )

mod1 <- MRBRT(
  data = dat1,
  cov_models = list(
    LinearCovModel("intercept", use_re = TRUE),
    LinearCovModel("x1") ) )

mod1$fit_model(inner_print_level = 5L, inner_max_iter = 1000L)

# df_pred1 <- data.frame(x1 = seq(0, 10, by = 2), study_id = "4")
df_pred1 <- data.frame(x1 = seq(0, 10, by = 0.1))

dat_pred1 <- MRData()

dat_pred1$load_df(
  data = df_pred1,
  col_covs=list('x1')
)



