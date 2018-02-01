## Libraries
library(tidyverse)
library(readr)
library(data.table)

## Set working directory and flatten images
knitr::opts_knit$set(root.dir = "C:/Users/Anike/Dropbox/Trademark Rebrand Project")
knitr::opts_chunk$set(dev = 'png', dpi = 300, echo=FALSE, message=FALSE, warning=FALSE, cache = TRUE, fig.pos = "H")

setwd("C:/Users/Anike/Dropbox/Trademark Rebrand Project")
# Owner files
owner <- read_csv("C:/Users/Anike/Dropbox/Trademark Rebrand Project/owner.csv/owner.csv")

# Prior Mark file
prior_mark <- read_csv("C:/Users/Anike/Dropbox/Trademark Rebrand Project/prior_mark.csv/prior_mark.csv")

# Case files
case_file <- read_csv("case_file.csv/case_file.csv")

new_file <- case_file %>%
  # Select relevant features
  select(serial_no, ir_auto_reg_dt, filing_dt, 
         registration_dt, related_other_in) %>% 
  # Merge with Prior Mark
  full_join(prior_mark, by = "serial_no") %>%
  # Merge with Owner Data
  full_join(owner, by="serial_no") %>%
  group_by(serial_no)

rm(case_file, owner, prior_mark)

new_file <- new_file %>%
  mutate(prior_regs = n_distinct(prior_no))

fwrite(new_file, "Trademarks 1884-2017.csv")

new_case_file2 <- new_case_file %>%
  select(serial_no, filing_dt, registration_dt, own_name, own_entity_cd, own_type_cd, own_addr_postal, own_id, prior_regs)

fwrite(new_case_file2, "Trademarks 1884-2017 (Reduced).csv")
