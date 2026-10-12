library(tidyr)
library(dplyr)
library(ggplot2)

#----------------------
# Basic data setup (from group report)

lr.data <- read.csv(
  "data/2019/2019_Food_Access_Research_Atlas_Data/Food Access Research Atlas.csv",
  stringsAsFactors = FALSE,
  na.strings = c("NA", "NULL", "")
)

lr.data <- as_tibble(lr.data)

# Convert CensusTract to character:
lr.data$CensusTract <- as.character(lr.data$CensusTract)

# Convert Urban/Rural to factor, with Urban as reference
lr.data$Urban_f <- factor(lr.data$Urban, levels=c(1,0), labels = c("Urban", "Rural"))



# Response variable
lr.data$LILATracts_halfAnd10_f <- factor(lr.data$LILATracts_halfAnd10,
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
for (v in num_vars) lr.data[[v]] <- as.numeric(lr.data[[v]])

# core_vars <- c("LA1and10", "PovertyRate", "MedianFamilyIncome", "Urban", "HUNVFlag")
# lr.data <- lr.data[complete.cases(lr.data[, core_vars]), ]

# compute populations as percentages
lr.data <- lr.data %>%
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

# compute populations as percentages
lr.data <- lr.data %>%
  mutate(
    TractLOWI_perc = TractLOWI_share * 100,
    TractKids_perc = TractKids_share * 100,
    TractSeniors_perc = TractSeniors_share * 100,
    TractWhite_perc = TractWhite_share * 100,
    TractBlack_perc = TractBlack_share * 100,
    TractAsian_perc = TractAsian_share * 100,
    TractNHOPI_perc = TractNHOPI_share * 100,
    TractAIAN_perc = TractAIAN_share * 100,
    TractOMultir_perc = TractOMultir_share * 100,
    TractHispanic_perc = TractHispanic_share * 100
  )

lr.data <- lr.data %>% mutate(
  l_TractSeniors_perc = log1p(TractSeniors_perc),
  l_TractKids_perc = log1p(TractKids_perc),
  l_TractWhite_perc = log1p(TractWhite_perc),
  l_TractBlack_perc = log1p(TractBlack_perc),
  l_TractHispanic_perc = log1p(TractHispanic_perc),
  l_TractAsian_perc = log1p(TractAsian_perc),
  l_TractNHOPI_perc = log1p(TractNHOPI_perc),
  l_TractAIAN_perc = log1p(TractAIAN_perc),
  l_TractOMultir_perc = log1p(TractOMultir_perc)
)

lr.data <- lr.data %>% 
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
    # TractLOWI_share,
    # TractKids_share, TractSeniors_share, 
    # TractWhite_share, TractBlack_share, TractAsian_share, TractNHOPI_share, TractAIAN_share, TractOMultir_share, TractHispanic_share
    # TractLOWI_perc,
    TractKids_perc, TractSeniors_perc, 
    TractWhite_perc, TractBlack_perc, TractAsian_perc, TractNHOPI_perc, TractAIAN_perc, TractOMultir_perc, TractHispanic_perc,
    
    # l_TractLOWI_perc,
    l_TractKids_perc, l_TractSeniors_perc, 
    l_TractWhite_perc, l_TractBlack_perc, l_TractAsian_perc, l_TractNHOPI_perc, l_TractAIAN_perc, l_TractOMultir_perc, l_TractHispanic_perc
  ) %>% 
  filter(
    !is.na(TractKids), 
    !(State %in% c("Hawaii", "Alaska")), # Hawaii ethnicity distributions are notably different 
    Pop2010 >= 150 # removes most extreme skews (percentage-based)
  ) 

View(lr.data)

