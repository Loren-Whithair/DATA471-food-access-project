
### What to do about impact on Urban / Rural?
# include Urban vs Rural, as it distinguishes the two scenarios

colnames(df)
[-c(1161, 63826, 63983),]

nrow(df)
df_clean <- filter(df, !(CensusTract %in% c(
  "4001942700", "48365950500" # abnormally large  demographic %s, Hispanic / AIAN
  ,"48341950200"
  )))


View(df[df$CensusTract=="48341950200",])
nrow(df_clean)



fit <- glm(
  LILATracts_halfAnd10_f ~
    TractAsian_perc * Urban_f
  + TractHispanic_perc #* Urban_f
  + TractNHOPI_perc #* Urban_f
  + TractAIAN_perc * Urban_f
  + TractOMultir_perc #* Urban_f
  + TractBlack_perc 
        # * TractKids_perc 
        # * Urban_f
  + TractAsian_perc 
        # * TractKids_perc 
        * Urban_f
  + TractHispanic_perc 
        * TractKids_perc 
        * Urban_f
  
  , family="binomial"
  # , data=df
  , data=df_clean # first lot of very clear outliers, based on abnormal demographic %s
)

# summary(fit)


View(df_clean[c(28159, 38920, 41830),])

hist(df_clean$TractKids_perc)

plot(
  fitted(fit),
  residuals(fit, type = "pearson"),
  xlab = "Predicted_values",
  ylab = "Pearson residuals"
)

influencePlot(fit) # low leverage, high residual...


hist(df$TractOMultir_perc)
hist(df$TractHispanic_perc)


fit.l <- glm(
  LILATracts_halfAnd10_f ~
    l_TractAsian_perc * Urban_f
  + l_TractHispanic_perc * Urban_f
  + l_TractNHOPI_perc #* Urban_f
  + l_TractAIAN_perc * Urban_f
  + l_TractOMultir_perc * Urban_f
  + l_TractBlack_perc 
      # * TractKids_perc
      # * Urban_f
  + l_TractAsian_perc 
      # * TractKids_perc
      # * Urban_f
  + l_TractHispanic_perc 
      # * l_TractKids_perc 
      # * Urban_f
  
  , family="binomial"
  # , data=df
  , data=df_clean # first lot of very clear outliers, based on abnormal demographic %s
)

summary(fit.l)


plot(fit, which=1)
plot(fit.l, which=1)
