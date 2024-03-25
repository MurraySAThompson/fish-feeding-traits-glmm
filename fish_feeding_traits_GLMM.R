# Author: Murray SA Thompson
# Contact: murray.thompson@cefas.gov.uk
# Version: 1
# March 2024

# data from: Thompson et al (2024). Modelled and observed fish feeding traits for the North Atlantic and Arctic Oceans (1836-2020) and population estimates of fish with different feeding traits from Northeast Atlantic scientific trawl surveys (1997-2020). Cefas, UK. V1. doi: https://doi.org/10.14466/CefasDataHub.149
# download data from: https://data.cefas.co.uk/#/View/21771
# metadata = 'COLUMN_HEADERS_README ID: 12748'
# stomach data = 'THOMPSON ET AL_STOMACH DATA OBSERVATIONS ID: 12750'

# load packages
pkgs = c("tidyverse", "glmmTMB", "patchwork", "parallel", "mapplots", "DHARMa") #,
for(p in pkgs){
  if(!require(p, character.only = TRUE)) install.packages(p)
  library(p, character.only = TRUE)
} 

# load stomach data (see data description)
stomdf = read_csv("stomach data observations.csv") %>%
  mutate(Year=as_factor(year),
         n_stom=as_factor(n_stom),
         Site=as_factor(Site),
         data_com=as_factor(data_com),
         pred_taxa=as_factor(pred_taxa),
         prey_funcgrp=as_factor(prey_funcgrp))

# Parallel optimization
nt = min(parallel::detectCores(),5) 

# fit the full model: intercept and slope varying by predator taxa and prey functional group; 
# random intercepts for data collations, year, site, and the number of stomachs pooled in a sample
set.seed(101)
full_mod = glmmTMB(L_ind_prey_b ~ L_pred_weight_g + 
                     (L_pred_weight_g | pred_taxa) + 
                     (L_pred_weight_g | prey_funcgrp) + 
                     (1| data_com) +
                     (1| Year) +
                     (1| Site) +
                     (1| n_stom),
                   control = glmmTMBControl(parallel = nt),
                   data = stomdf,
                   family=t_family(link="identity")) 
summary(full_mod) 

# for diagnostic plots, plot simulated residuals which can take minutes to generate:
#plot(simulateResiduals(full_mod))

# now we have the model, we can make specific predictions on new data.
# For example, take a random sample of data used in the model, make predictions, 
# and then compare with observed values as follows

# columns of interest
vars = c('L_ind_prey_b', 'L_pred_weight_g', 'pred_taxa', 'prey_funcgrp')

# random sample of data used in the model
set.seed(199)
new_preds = slice_sample(full_mod$frame[,vars], n=10000) %>%
  # add other columns used in the model, using NA if not of interest
  mutate(n_stom='1', # number of stomachs sampled = 1 (2 = where stomach samples were pooled)
         Site='2_3', # covers most UK waters, refer to Fig. S1
         Year=NA, # where year is not of interest 
         data_com=NA, # where differences in data, e.g. between ICES and DAPSTOM, not of interest
         taxa_func = paste(pred_taxa, prey_funcgrp, sep='_')) # pred-prey combination for plotting

# make predictions
p=predict(full_mod,  newdata=new_preds, allow.new.levels = TRUE, re.form = NULL)

# degrees of freedom for the Student distribution (note fit with log-link in glmmtmb, hence exp(df) below))
df=family_params(full_mod) 

# simulated_data: randomly sample from a student distribution with given mean (ncp), dfs and n (glmmtmb fits using log df)
simulated_data=rt(n=dim(new_preds)[1],df=exp(df),ncp=p) 

# add predictions
new_preds$sims = simulated_data 
new_preds$fit = p
summary(new_preds)

# select relationships to plot, here I have selected the top 10 ranked by n observations
plts = new_preds %>%
  group_by(taxa_func) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  head(10) %>%
  pull(taxa_func)


# plot of fitted values and simulated data
p1 = new_preds %>%
  filter(taxa_func %in% plts) %>%
  ggplot(aes(x=L_pred_weight_g, y=fit, color=taxa_func)) + 
  geom_smooth(method=lm) +
  geom_point(aes(x=L_pred_weight_g, y=sims, color=taxa_func), 
             size = 1.2,
             alpha=0.1, 
             shape=3) +
  geom_abline(intercept = -2,
              slope = 1,
              linetype = 2,
              colour = 'black') +
  #guides(colour="none") +
  labs(x=expression('Log'[10]~'(predator mass [g])'),
       y=expression('Log'[10]~'(prey mass [g])'), 
       title='Predictions') +
  theme(text = element_text(size=15),
        legend.title = element_blank(),
        panel.background = element_rect(fill = 'white'), 
        panel.border = element_rect(colour='black', fill=NA),
        panel.grid  = element_blank())

# plot of observations 
p2 = new_preds %>%
  filter(taxa_func %in% plts) %>%
  ggplot(aes(x=L_pred_weight_g, y=L_ind_prey_b, color=taxa_func)) + 
  geom_smooth(method=lm, se=F)  +
  geom_point(aes(x=L_pred_weight_g, y=L_ind_prey_b, color=taxa_func), 
             size = 1.2,
             alpha=0.1, 
             shape=3, 
             show.legend = F) +
  geom_abline(intercept = -2,
              slope = 1,
              linetype = 2,
              colour = 'black') +
  guides(colour="none") +
  labs(x=expression('Log'[10]~'(predator mass [g])'),
       y=expression('Log'[10]~'(prey mass [g])'), 
       title='Observations') +
  theme(text = element_text(size=15),
        legend.title = element_blank(),
        panel.background = element_rect(fill = 'white'), 
        panel.border = element_rect(colour='black', fill=NA),
        panel.grid  = element_blank())

# plot using patchwork:
p1/p2 + plot_layout(guides = "collect")
