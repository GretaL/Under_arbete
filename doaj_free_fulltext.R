library(tidyverse)
library(stringr)

#Läs in data från DiVA. Vi använder en csvall2-fil.
diva <- read_csv(file = "/home/shub/assets/diva/diva_researchpubl_latest.csv")
doaj_listan <- read_csv("/home/shub/assets/doaj.csv")

diva$JournalISSN[is.na(diva$JournalISSN)] <- 0L
diva$JournalEISSN[is.na(diva$JournalEISSN)] <- 0L
diva$FreeFulltext[diva$FreeFulltext == "true"] <- TRUE

diva_art_rec <- diva %>%
  filter(between(Year, 2010, 2018)) %>%
  filter(PublicationType %in% c("Artikel, forskningsöversikt", "Artikel i tidskrift", "Artikel, recension")) %>%
  mutate(doaj = ((JournalISSN %in% doaj_listan$`Journal ISSN (print version)`)|
                   (JournalEISSN %in% doaj_listan$`Journal EISSN (online version)`)))%>%
  select(PID, Name, Title, Journal,JournalISSN, JournalEISSN, Year, ContentType, PublicationSubtype, Status, 
         DOI, Urls, FreeFulltext, doaj)

write_csv(diva_art_rec, "doaj.csv")
