### get model from detailed-analysis-draft.Rmd

library(dplyr)
library(tidyr)
library(ggplot2)

summary(model)


# robustness -------------

# nrow(lr.data.clean)
# length(predict(model))
# 
# lr.out <- lr.data.clean %>% mutate(
#   model.fitted = fitted(model),
#   model.predict = predict(model)
#   
#   #, model.predict_LILA= as.integer(predict(model, type="response") >= 0.5)
# )
# 
# colnames(lr.out)
# 
# 
# View(lr.out)


ggplot(lr.out, 
       aes(
         x=l_TractBlack_perc,
         y=model.fitted
       )) +
  geom_point(
    alpha=0.1,
    colour="darkblue"
  ) + labs(
    x="Percentage of tract that is black (natural log of adjusted value)",
    y="Fitted model value"
  ) +
  geom_abline(slope= 0.15,
              intercept=0.0,
              colour="red",
              size=1
  ) + theme_minimal()



unique(lr.out$Urban_f)

lr.out[lr.out$Urban_f=="Urban",]

ggplot(
  # lr.out[lr.out$Urban_f=="Urban",]
  # lr.out[lr.out$Urban_f=="Rural",]
  lr.out
  , aes(
    # x=l_TractAsian_perc,
    x=l_TractHispanic_perc,
    # x=l_TractHispanic_perc,
    # x=l_TractHispanic_perc,
    # x=l_TractHispanic_perc,
    # x=l_TractHispanic_perc,
    # x=l_TractHispanic_perc,
    # x=l_TractHispanic_perc,
    # x=l_TractHispanic_perc,
    y=model.fitted,
    colour=Urban_f
  )) +
  geom_point(
    alpha=0.1
    # ,colour="darkblue"
  ) + labs(
    x="Percentage of tract that is black (natural log of adjusted value)",
    y="Fitted model value",
    colour="Population Density type"
  ) + 
  theme_minimal() + 
  scale_colour_brewer(palette = "Set1") +
  geom_abline(slope= 0.05,
              intercept=0.1,
              colour="black",
              size=1
  ) + 
  geom_abline(slope= 0.001,
              intercept=0.05,
              colour="black",
              size=1
  ) +
  guides(colour = guide_legend(override.aes = list(alpha = 1)))


  
# coefficient interpretation ------------

summary(model)
ci <- confint(model) # must take exponent of this too!
beta <- summary(model)$coeff

# the odds are x times more / less
exp(cf)

colnames(lr.data)


hist(lr.data.clean$TractBlack_perc)
hist(lr.data.clean$TractHispanic_perc)
hist(lr.data.clean$TractAsian_perc)
hist(lr.data.clean$TractWhite_perc)

hist(lr.data.clean$TractOMultir_perc) # less of a tail, does this have an effect on why it's biggest?




mean(lr.data.clean$TractBlack_perc)
var(lr.data.clean$TractBlack_perc)



### load data again, to have all columns
all.data <- read.csv(
  "data/2019/2019_Food_Access_Research_Atlas_Data/Food Access Research Atlas.csv",
  stringsAsFactors = FALSE,
  na.strings = c("NA", "NULL", "")
)

all.data <- as_tibble(all.data)

# Convert CensusTract to character:
all.data$CensusTract <- as.character(all.data$CensusTract)

# Convert Urban/Rural to factor, with Urban as reference
all.data$Urban_f <- factor(all.data$Urban, levels=c(1,0), labels = c("Urban", "Rural"))


# Response variable
all.data$LILATracts_halfAnd10_f <- factor(all.data$LILATracts_halfAnd10,
                                         levels=c(0,1),
                                         labels = c("Not low income/access", "Low income/access"))

# Relevant numerical variables
num_vars <- c(
  "Pop2010", "OHU2010",
  "PovertyRate", "MedianFamilyIncome", 
  "TractLOWI",
  "TractKids", "TractSeniors",
  "TractWhite", "TractBlack", "TractAsian", "TractNHOPI", "TractAIAN","TractOMultir", "TractHispanic"
)
for (v in num_vars) all.data[[v]] <- as.numeric(all.data[[v]])




p1 <- all.data %>%
  filter(Urban_f =="Urban") %>%
  ggplot() +
  geom_histogram(aes(x=laomultirhalfshare))


p2 <- all.data %>%
  filter(Urban_f =="Rural") %>%
  ggplot() +
  geom_histogram(aes(x=laomultir10share))

p1 + p2
