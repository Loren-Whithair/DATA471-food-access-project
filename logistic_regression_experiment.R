library(tidyr)
library(dplyr)
library(ggplot2)
library(regressinator)
library(visreg)

# check the 
head(df)

# fit a logistic regression model


plot(df$TractBlack_share, df$TractKids_share)
plot(df$TractBlack_share, df$TractSeniors_share)

# TODO: what is the reference ethnicity?
colnames(df)
fit <- glm(
  LILATracts_halfAnd10_f ~ 
    Urban_f +
    TractKids_share + 
    TractSeniors_share +
    TractWhite_share + 
    TractBlack_share + 
    TractHispanic_share + 
    TractAsian_share +
    # interaction vars w Urban
    TractKids_share*Urban_f + 
    TractSeniors_share*Urban_f +
    TractWhite_share*Urban_f + 
    TractBlack_share*Urban_f + 
    TractHispanic_share*Urban_f + 
    TractAsian_share*Urban_f,
  family="binomial",
  
  data=df
)

#---------
# look at summary
summary(fit) # raw values
exp((summary(fit)$coeff[,"Estimate"])) # exponentiating to turn it into odds



fit2 <- glm(
  LILATracts_halfAnd10_f ~ 
    Urban_f +
    # ethnicity + age
    TractKids_share +
    TractSeniors_share +
    TractWhite_share +
    TractBlack_share + 
    TractHispanic_share + 
    TractAsian_share +
    # interaction vars: urban +
    TractKids_share*Urban_f + 
    TractSeniors_share*Urban_f +
    TractWhite_share*Urban_f + 
    TractBlack_share*Urban_f + 
    TractHispanic_share*Urban_f + 
    TractAsian_share*Urban_f
  # +
    # TractWhite_share*TractKids_share # adding this makes other things way more significant... multicollinearity? 
  ,
  family="binomial",
  
  data=df
)

summary(fit2)

exp(confint(fit2))


fit4 <- glm(
  LILATracts_halfAnd10_f ~ 
    # Urban_f +
    # ethnicity + age
    # TractKids_share +
    TractSeniors_share +
    # TractWhite_share + 
    TractBlack_share + 
    # TractHispanic_share + 
    TractAsian_share +
    # interaction vars: urban +
    TractKids_share*Urban_f + 
    TractSeniors_share*Urban_f +
    # TractWhite_share*Urban_f +
    # TractBlack_share*Urban_f +
    # TractHispanic_share*Urban_f +
    TractAsian_share*Urban_f 
    + TractWhite_share * TractKids_share * Urban_f # adding this makes other things way more significant...
    + TractKids_share * TractBlack_share * Urban_f
  ,   
  family="binomial",
  data=df
)

fit5 <- glm(
  LILATracts_halfAnd10_f ~ 
    # Urban_f +
    # ethnicity + age
    # TractKids_share +
    # TractSeniors_share +
    # TractWhite_share + 
    # TractBlack_share + 
    # TractHispanic_share + 
    # TractAsian_share +
    # interaction vars: urban +
    # TractKids_share*Urban_f + 
    # TractSeniors_share*Urban_f +
    # TractWhite_share*Urban_f +
    # TractBlack_share*Urban_f +
    # TractHispanic_share*Urban_f +
    # TractAsian_share*Urban_f 
  + TractWhite_share * TractKids_share * Urban_f # adding this makes other things way more significant...
  + TractKids_share * TractBlack_share #* Urban_f
  + TractKids_share * TractHispanic_share #* Urban_f
  + TractKids_share * TractAsian_share #* Urban_f
  
  
  ,   
  family="binomial",
  data=df
)

exp(summary(fit5)$coeff)

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

summary(fit3)
summary(fit4) # without white*kids interaction

model <- fit4

# summary(fit)$coef
# TODO: residual analysis



# residuals, general predictive performance

## prediction performance over training data?
df$model_prob <- predict(model, df, type="response")

df <- df %>% mutate(model_pred = 1*(model_prob > .5) + 0)


plot(df$TractWhite_share, df$TractKids_share)


#
ggplot(fit4) + geom_point(aes(y=.fitted, x=TractWhite_share), size=0.2) + theme(text = element_text(size=16))

# look at partial residuals
regressinator::partial_residuals(fit4) |>
  ggplot(aes(x = .predictor_value, y=.partial_resid)) +
  geom_point() +
  geom_smooth() +
  geom_line(aes(x = .predictor_value, y=.predictor_effect)) +
  facet_wrap(vars(.predictor_name), scales="free") +
  labs(x = "Predictor", y="Partial residual")


regressinator::partial_residuals(fit4)
nrow(df)

# see series of residual plots
plot(fit4)


plot(
  fitted(fit4),
  residuals(fit4, type="deviance"),
  xlab="Fitted probability",
  ylab="Deviance residual"
     )

quantile(residuals(fit4))


# # outliers are found in Hawaii... 
# View(df[c(20177, 20209),])
# View(df[df$State=="Hawaii",])



