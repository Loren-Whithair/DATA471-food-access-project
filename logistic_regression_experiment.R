
# check the 
head(df)

# fit a logistic regression model

# TODO: what is the reference ethnicity?
colnames(df)
fit <- glm(
  LILATracts_halfAnd10_f ~ 
    Urban_f +
    TractKids_share + TractSeniors_share +
    TractWhite_share + TractBlack_share + TractHispanic_share + TractAsian_share +
    # interaction vars
    TractKids_share*Urban_f + TractSeniors_share*Urban_f +
    TractWhite_share*Urban_f + TractBlack_share*Urban_f + TractHispanic_share*Urban_f + TractAsian_share*Urban_f,
  
  family="binomial",
  
  data=df
)

#---------
# look at summary
summary(fit) # raw values
exp((summary(fit)$coeff[,"Estimate"])) # exponentiating to turn it into odds


# summary(fit)$coef
# TODO: residual analysis


# 