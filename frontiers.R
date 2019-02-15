#
#Frontiers
#180829 GL
#Artiklar av SHforskare i tidskrifter från Frontiers
#
#

library(tidyverse)

diva <- read_csv("/home/shub/assets/diva/diva_researchpubl_sh_latest.csv")
frontiers <- read_excel("Frontiers.xlsx")

artiklar <- diva %>%
  filter(PublicationType == "Artikel i tidskrift"|PublicationType == "Artikel, forskningsöversikt") %>%
  select(PID, Name, Title, Journal, JournalISSN, JournalEISSN, Year)

f_artiklar <- artiklar %>%
  mutate(frontiers = match(JournalISSN, frontiers$ISSN, nomatch = 0))%>%
  filter(frontiers != 0)

write_csv(f_artiklar, "Fronesis")
