# Data Exploration


#### Set-Up ####

## Load relevant libraries
library(dplyr)
library(ggplot2)
library(tidyr)

## Check working directory (should be 'Mada_DHS')
getwd()

## Read in the first csv
data <- read.csv("infectious_diseases_indicators_mdg.csv")


#### Clean Up the Data ####
View(data)

### Keep the code, display, year, and display value. Remove the first row.
data <- data %>%
  select(GHO..CODE., GHO..DISPLAY., YEAR..CODE., Display.Value) %>%
  slice(-1)

### Rename the year and count columns
data <- data %>%
  rename(year = YEAR..CODE.,
         count = Display.Value)

### New column for disease, new column for type of reporting
data <- data %>%
  mutate(disease = "cholera",
         type = "case")

data[data$GHO..CODE. == "MENING_1", "disease"] <- "meningitis"
data[data$GHO..CODE. == "WHS3_49", "disease"] <- "poliomyelitis"
data[data$GHO..CODE. == "WHS3_41", "disease"] <- "diptheria"
data[data$GHO..CODE. == "WHS3_42", "disease"] <- "japanese_encephalitis"
data[data$GHO..CODE. == "WHS3_43", "disease"] <- "pertussis"
data[data$GHO..CODE. == "WHS3_46", "disease"] <- "tetanus"
data[data$GHO..CODE. == "WHS3_50", "disease"] <- "yellow_fever"
data[data$GHO..CODE. == "WHS3_53", "disease"] <- "mumps"
data[data$GHO..CODE. == "WHS3_55", "disease"] <- "congenital_rubella"
data[data$GHO..CODE. == "WHS3_56", "disease"] <- "neonatal_tetanus"
data[data$GHO..CODE. == "WHS3_57", "disease"] <- "rubella"
data[data$GHO..CODE. == "WHS3_62", "disease"] <- "measles"

data[data$GHO..CODE. == "MENING_1", "type"] <- "suspected_death"
data[data$GHO..CODE. == "CHOLERA_0000000002", "type"] <- "death"
data[data$GHO..CODE. == "CHOLERA_0000000003", "type"] <- "fatality_rate"

### Organize
data <- data %>%
  select(year, disease, type, count) %>%
  arrange(year)


#### Ideas ####

# cholera death vs case
# neonatal tetanus as % of all tetanus


#### Concept 1 ####

### Graph 1: Cases over time (line graph) with all diseases
deaths_line_all <- data %>%
 filter(type %in% "case") %>%
 ggplot() +
 aes(x = year, y = count, colour = disease) +
 geom_line() +
 scale_color_hue(direction = 1) +
 labs(x = "Year", y = "Cases", title = "Cases of Infectious Diseases in Madagascar", subtitle = "1971 - 2022") +
 theme_minimal() +
 theme(plot.title = element_text(size = 15L, hjust = 0.5), plot.subtitle = element_text(face = "italic", 
 hjust = 0.5))

deaths_line_all


#### Concept 2 ####

## Transform to cholera-specific wide data - each year has just one row

### Filter down
data_cholera <- data %>%
  filter(disease == "cholera") %>%
  filter(type != "fatality_rate")

### Pivot
data_cholera <- data_cholera %>%
  pivot_wider(names_from = type, values_from = count, values_fill = 0)

### Graph 2: Cholera cases vs deaths

library(ggplot2)

cholera_cases_deaths <- ggplot(data_cholera) +
  aes(x = year, y = death) +
  geom_line(colour = "#112446") +
  geom_line(data = data_cholera, aes(x = year, y = case), colour = "#FF5733") +
  labs(x = "Year", y = "Count", 
       title = "Cholera Deaths vs Cases", subtitle = "1971 - 2006") +
  theme_minimal()

cholera_cases_deaths

    #### idea - could put fatality_rate values as text boxes over the years with deaths








