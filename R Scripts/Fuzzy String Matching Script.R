library(tidyverse)
library(fuzzyjoin)

# Load Datasets
EntityRef <- read.csv("EntityRef.csv")
UniqueCompanies <- read.csv("Unmatched Owner Names.csv")

# Lowercase
EntityRef$companyName <- tolower(EntityRef$companyName)
UniqueCompanies <- tolower(UniqueCompanies$OwnerName)

# Separate EntityRef into Three Smaller Datasets and Reduce File Size

EntityRefOne <- EntityRef %>% slice(1:3000)
EntityRefTwo <- EntityRef %>% slice(3001:6000)
EntityRefThree <- EntityRef %>% slice(6001:8066)


MatchesOne <- stringdist_inner_join(EntityRefOne, UniqueCompanies, by=c("companyName"="OwnerName"), max_dist=10, method="lv", distance_col="Distance")

MatchesOne %>%
  group_by(companyName) %>%
  filter(Distance == min(Distance))

MatchesTwo <- stringdist_inner_join(EntityRefTwo, UniqueCompanies, by=c("companyName"="OwnerName"), max_dist=10, method="lv", distance_col="Distance")

MatchesTwo %>%
  group_by(companyName) %>%
  filter(Distance == min(Distance))

MatchesThree <- stringdist_inner_join(EntityRefThree, UniqueCompanies, by=c("companyName"="OwnerName"), max_dist=10, method="lv", distance_col="Distance")

MatchesThree %>%
  group_by(companyName) %>%
  filter(Distance == min(Distance))

Matches <- MatchesOne %>% bind_rows(Matches_Two, Matches_Three)

write.csv(Matches, "Matches.csv") 