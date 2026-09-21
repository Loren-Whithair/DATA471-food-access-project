library(tidyr)
library(dplyr)
library(ggplot2)

#----------------------
# Basic data setup (from group report)

df <- read.csv(
  "data/2019/2019_Food_Access_Research_Atlas_Data/Food Access Research Atlas.csv",
  stringsAsFactors = FALSE,
  na.strings = c("NA", "NULL", "")
)

df <- as_tibble(df)

# Convert CensusTract to character:
data$CensusTract <- as.character(data$CensusTract)

# Convert Urban/Rural to factor, with Urban as reference
df$Urban_f <- factor(df$Urban, levels=c(1,0), labels = c("Urban", "Rural"))



# Response variable
df$LILATracts_halfAnd10_f <- factor(df$LILATracts_halfAnd10,
                                    levels=c(0,1),
                                    labels = c("Not low income/access", "Low income/access"))


# df$LA1and10_f <- factor(df$LA1and10, levels=c(0,1), labels = c("Not low access", "Low access"))


# Relevant numerical variables
num_vars <- c(
  "Pop2010", "OHU2010",
  "PovertyRate", "MedianFamilyIncome", 
  "TractLOWI",
  "TractKids", "TractSeniors",
  "TractWhite", "TractBlack", "TractAsian", "TractNHOPI", "TractAIAN","TractOMultir", "TractHispanic"
)
for (v in num_vars) df[[v]] <- as.numeric(df[[v]])

# core_vars <- c("LA1and10", "PovertyRate", "MedianFamilyIncome", "Urban", "HUNVFlag")
# df <- df[complete.cases(df[, core_vars]), ]

# compute populations as percentages
df <- df %>%
  mutate(
    TractLOWI_share = TractLOWI / Pop2010,
    TractKids_share = TractKids / Pop2010,
    TractSeniors_share = TractSeniors / Pop2010,
    TractWhite_share = TractWhite / Pop2010,
    TractBlack_share = TractBlack / Pop2010,
    TractAsian_share = TractAsian / Pop2010,
    TractNHOPI_share = TractNHOPI / Pop2010,
    TractAIAN_share = TractAIAN / Pop2010,
    TractOMultir_share = TractOMultir / Pop2010,
    TractHispanic_share = TractHispanic / Pop2010
  )

df <- df %>% 
  select(
    CensusTract, State, County,  # identifying info
    LILATracts_halfAnd10_f, LILATracts_halfAnd10, # response var
    # predictor + supporting vars
    Pop2010,
    Urban, Urban_f,
    TractLOWI, 
    TractKids, TractSeniors, 
    TractWhite, TractBlack, TractAsian, TractNHOPI, TractAIAN, TractOMultir, TractHispanic, 
    # TractHUNV, TractSNAP, 
    TractLOWI_share,
    TractKids_share, TractSeniors_share, 
    TractWhite_share, TractBlack_share, TractAsian_share, TractNHOPI_share, TractAIAN_share, TractOMultir_share, TractHispanic_share
  ) %>% 
  filter(!is.na(TractKids))


View(df)

