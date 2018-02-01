library(tidyverse)

## Read CSV
memory.limit(size=35000)
setwd("C:/Users/Owner/Dropbox/Trademark Rebrand Project")
Trademarks <- read_csv("C:/Users/Owner/Dropbox/Trademark Rebrand Project/Trademarks 1884-2017 (Reduced).csv")
EntityRef <- read_csv("c:/Users/Owner/Dropbox/Trademark Rebrand Project/EntityRef.csv")

## Preliminary Analysis

Trademarks$filing_dt <- as.Date(Trademarks$filing_dt, format="%Y-%m-%d")
Trademarks$registration_dt <- as.Date(Trademarks$registration_dt, format="%Y-%m-%d")
Trademarks$Year <- format(Trademarks$filing_dt, "%Y")

# Bar plot
PriorRegBar <- Trademarks %>%
                          filter(own_entity_cd == 3) %>%
                          group_by(Year, prior_regs) %>%
                          summarise(n=n()) %>%
                          ggplot() + aes(x=Year, y = n, fill = prior_regs) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + xlab("Year") + ylab("Number of Prior Marks") + ggtitle("Barplot of Relative Proportions of Corporate Trademark Prior Marks 1884-2017")

# Scatter Plot
PriorRegScatter <- Trademarks %>%
                              filter(own_entity_cd == 3)
                              group_by(Year, prior_regs) %>%
                              summarise(n=n()) %>%
                              ggplot() + aes(x=Year, y=n) + geom_point() + geom_line(color="red") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + xlab("Year") + ylab("Number of Prior Marks") + ggtitle("Barplot of Relative Proportions of Corporate Trademarks Prior Marks 1884-2017")