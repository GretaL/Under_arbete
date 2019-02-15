#
#
#publicering_hogskolan
#190121 GL
#Publikationstyper. Artiklar indexerade i WoS, Scopus, Norska listan och DOAJ.
#
#

library(tidyverse)

source('/home/shub/src/common/lib/sh_parameters.R')
source('/home/shub/src/common/lib/sh_diva_bibliometrics_functions.R')

sh_archive_start("Publicering")

doaj_listan <- read_csv("/home/shub/assets/doaj.csv")

#Läs in issn för Norska listan. Kopierat från Bibl.index (Camillas). Allt står i nerladdningsskriptet.
n_issn <- read.csv(file="/home/shub/assets/nsd.issn.csv",
                   header=TRUE,
                   sep=";",
                   na.strings = c("", "NA"),
                   stringsAsFactors = FALSE,
                   encoding = "latin1")

n_issn <- n_issn %>%
  select(-matches("Nivå.idag"))
current_year <- as.integer(format(Sys.time(), "%Y"))
nr_of_years <- current_year - 2004 + 1
col_names <- names(n_issn)
kol_index <- vector("integer", nr_of_years)
for (i in seq_along(kol_index)) {
  names(kol_index)[[i]] <- current_year + 1 - i #lägger in åren som names tex 2017+1-1 =2017, räknar sedan ner med ##i
  year <- names(kol_index)[[i]] #skapar en tillfällig vektor med det aktuella året, tex 2017
  kol_index[[i]] <- grep(year, col_names) #lägger in kolumnnamnet från n_issn som element genom att söka på år ##i n_issns kolumnnamn.
}

diva <- read_csv("/home/shub/assets/diva/diva_researchpubl_sh_latest.csv")

diva$JournalISSN[is.na(diva$JournalISSN)] <- 0L
diva$JournalEISSN[is.na(diva$JournalEISSN)] <- 0L
diva$FreeFulltext[diva$FreeFulltext == "true"] <- TRUE

#Enbart publicerad artiklar
diva_art <- diva %>%
  filter(between(Year, 2014, 2018)) %>%
  filter(PublicationType %in% c("Artikel, forskningsöversikt", "Artikel i tidskrift")) %>%
  filter(Status == "published") %>%
  mutate(doaj = ((JournalISSN %in% doaj_listan$`Journal ISSN (print version)`)|
                   (JournalEISSN %in% doaj_listan$`Journal EISSN (online version)`)))%>%
  mutate(nsd = ((JournalISSN %in% n_issn$`Print.ISSN`)|
                  (JournalEISSN %in% n_issn$`Online.ISSN`)))%>%
  select(PID, Name, Title, Journal,JournalISSN, JournalEISSN, Year, ContentType, PublicationSubtype, Status, 
         ISI, ScopusId, FridaLevel, nsd, FullTextLink, FreeFulltext, doaj)



#Arkivering
sh_archive_df(diva, "DiVA_rådata.csv")
sh_archive_df(n_issn, "Norska_issn.csv")
sh_archive_df(diva_art, "Artiklar.csv")
sh_archive_end()
