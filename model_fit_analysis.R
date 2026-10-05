# #### Prelim: build model ------
# model <- glm(
#   LILATracts_halfAnd10_f ~ 
#     # ethnicity + age
#     + TractSeniors_perc*Urban_f
#     # + TractHispanic_perc
#     + TractHispanic_perc*Urban_f
#     + TractAsian_perc*Urban_f
#     + TractWhite_perc
#     + TractBlack_perc * Urban_f
#       
#   family="binomial",
#   data=df
# )

model <- glm(
  LILATracts_halfAnd10_f ~ 
    TractSeniors_perc +
    TractAsian_perc +
    TractSeniors_perc*Urban_f +
    TractHispanic_perc*Urban_f +
    TractAsian_perc*Urban_f 
  + TractWhite_perc
  + TractKids_perc * TractBlack_perc
  + TractHispanic_perc * Urban_f
  ,   
  family="binomial",
  data=df
)

summary(model)

exp(summary(model)$coeff)

# MODEL FIT -----
plot(fit4) # first value is fitted vs residuals


# qq plot too - how similar something is to a normal distribution (quantile plot)
# but for logistic regression not necessarily a correct assumption

# confusion matrix to indicate model fit - or could show R^2

# NOTES:
# statistically significant - also loook at size

## residuals - look at fittedv sresiduals
# .fitted shows the log odds values 

# look for non-linearity - that would say that the way that we've modelled it doesn't represent the true models
# often logging the predictors can help


# can pick out 
# is the plot linear?
#

## outlier measures ----


library(olsrr)

sort(dffits(model))

# see hatvalues against studentised residuals
influencePlot(model)

# shows the following:
# - point 1180 and 64689 have high discrepancy, low leverage. High regular residuals too

View(df[c(1180, 64689),])
# seem to have very high percentages of certain demographics that otherwise tend to be very low, such as 
# % hispanic, % AIAN

# TractAIAN
hist(df[df$TractAIAN_perc < 20,]$TractAIAN_perc)

View(df[df$TractAIAN_perc > 20,])


## Population size weirdness
df %>% filter(Pop2010 < 1000) %>% ggplot() + geom_histogram(aes(x=Pop2010))

View(df[df$Pop2010<100,])

