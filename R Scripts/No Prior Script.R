library(tidyverse)
library(readr)

setwd("C:/Users/Anike/Dropbox/Trademark Rebrand Project")
case_file <- read_csv("C:/Users/Anike/Dropbox/Trademark Rebrand Project/case_file.csv/case_file.csv")
prior_mark <- read_csv("C:/Users/Anike/Dropbox/Trademark Rebrand Project/prior_mark.csv/prior_mark.csv")
owner_file <- read_csv("C:/Users/Anike/Dropbox/Trademark Rebrand Project/owner.csv/owner.csv")


prior_regs <- prior_mark %>%
  summarise(n_distinct(serial_no))

new_file <- case_file %>% # Start with the Case File
  # Select variables of interest
  select(serial_no, ir_auto_reg_dt, filing_dt, registration_dt, related_other_in) %>%
  # Merge Prior Mark data in, matching by "serial number" and retain all values
  anti_join(prior_mark, by="serial_no") %>%
  # Merge Owner data in, matching by "serial number" and retain all values
  full_join(owner_file, by="serial_no") %>%
  # Subset to corporations only (legal entity ID = 3)
  filter(own_entity_cd == 3) 

new_file$filing_dt <- as.Date(new_file$filing_dt, format="%Y-%m-%d") # Convert filing date variable to date class
new_file$registration_dt <- as.Date(new_file$registration_dt, format="%Y-%m-%d") # Convert registration date variable to date class
new_file$Year <- format(new_file$filing_dt, "%Y") # Extract Year from filing date

NoPriorFreqTable <- new_file %>%
  drop_na(Year) %>%
  group_by(Year) %>%
  summarise(count = n_distinct(serial_no))

NoPriorFreqTable$Year <- as.numeric(NoPriorFreqTable$Year)
NoPriorPlot <- NoPriorFreqTable %>%
  ggplot() + geom_point(aes(x=Year, y=count)) + ggtitle("Instances of Zero Prior Registrations Over Time") + xlab("Year") + ylab("Number of Instances") + geom_vline(xintercept = 1975) +
  theme(axis.text.x = element_text(angle=90))
