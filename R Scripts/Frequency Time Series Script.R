library(tidyverse)
library(readr)
setwd("C:/Users/Anike/Dropbox/Trademark Rebrand Project")
FreqTable <- read.csv("Frequency Table of Prior Marks by Year.csv")
Matches <- read.csv("Matches.csv")
Trademarks <- read_csv("Trademarks 1884-2017.csv")

Trademarks$registration_dt <- as.Date(Trademarks$registration_dt, format = "%Y-%m-%d")
Trademarks$Year <- format(Trademarks$registration_dt, "%Y")

# Graphs on Full Data

OnePrior <- FreqTable %>%
              filter(prior_regs == 1) %>%
              ggplot() + geom_point(aes(x=Year, y=n)) + ggtitle("Instances of One Prior Registration Over Time") + xlab("Year") + ylab("Number of Instances") + geom_vline(xintercept=1975)

OnetoThree <- FreqTable %>%
                filter(prior_regs < 4) %>%
                ggplot() + geom_point(aes(x=Year, y=n)) + facet_wrap(~prior_regs) + ggtitle("Instances of One, Two, and Three Prior Registrations Over Time") + xlab("Year") + ylab("Number of Instances") + geom_vline(xintercept=1975)

FourtoTen <- FreqTable %>%
                filter(prior_regs > 3 & prior_regs < 11) %>%
                ggplot() + geom_point(aes(x=Year, y=n)) + facet_wrap(~prior_regs) + ggtitle("Instances of 4-10 Prior Registrations Over Time") + xlab("Year") + ylab("Number of Instances") + geom_vline(xintercept = 1975)

# Matched Trademarks for the past 40 years

SampleMatches <- Matches %>%
                    filter(Distance < 2) %>%
                    distinct(OwnerName)

MatchedTrademarks <- Trademarks %>%
                        filter(tolower(own_name) %in% SampleMatches$OwnerName)

test <- Trademarks %>%
  filter(Year > 2003)

write.csv(MatchedTrademarks, "SEC Trademarks 1884-2017.csv")

# Graphs on Matched Data

MatchedTrademarks$filing_dt <- as.Date(MatchedTrademarks$filing_dt, format="%Y-%m-%d")
MatchedTrademarks$registration_dt <- as.Date(MatchedTrademarks$registration_dt, format="%Y-%m-%d")
MatchedTrademarks$Year <- format(MatchedTrademarks$filing_dt, format="%Y")
MatchedTrademarks$Year <- as.numeric(MatchedTrademarks$Year)

MatchedFreqTable <- MatchedTrademarks %>%
                      drop_na(Year) %>%
                      count(Year, prior_regs) %>%
                      mutate(prop = prop.table(n))

MatchOnePrior <- MatchedFreqTable %>%
                      filter(prior_regs == 1) %>%
                      ggplot() + geom_point(aes(x=Year, y=n)) + facet_wrap(~prior_regs) + ggtitle("Instances of One Prior Registration Over Time in SEC Data") + xlab("Year") + ylab("Number of Instances") + geom_vline(xintercept = 1975)

MatchOnetoThree <- MatchedFreqTable %>%
                      filter(prior_regs < 4) %>%
                      ggplot() + geom_point(aes(x=Year, y=n)) + facet_wrap(~prior_regs) + ggtitle("Instances of One, Two, and Three Prior Registrations Over Time in SEC Data") + xlab("Year") + ylab("Number of Instances") + geom_vline(xintercept = 1975)

MatchFourtoTen <- MatchedFreqTable %>%
                      filter(prior_regs > 3 & prior_regs < 11) %>%
                      ggplot() + geom_point(aes(x=Year, y=n)) + facet_wrap(~prior_regs) + ggtitle("Instances of 4-10 Prior Registration Over Time in SEC Data") + xlab("Year") + ylab("Number of Instances") + geom_vline(xintercept = 1975)

write.csv(MatchedFreqTable, "Frequency Table for SEC Data.csv")

CompanySummary <-MatchedTrademarks %>%
  group_by(own_name) %>%
  summarise(avgperyear = n_distinct(serial_no)/n_distinct(Year)) 

CompanySummarypost1975 <- MatchedTrademarks %>%
  filter(Year > 1974) %>%
  group_by(own_name) %>%
  summarise(avgpost1975 = n_distinct(serial_no)/n_distinct(Year))

CompanySummary <- CompanySummary %>% full_join(CompanySummarypost1975, by="own_name")

write.csv(CompanySummary, "Company Summary.csv")
