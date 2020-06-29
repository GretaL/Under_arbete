#
#
#uppfoljning_publicering_sh
#GL 200226
#Tabeller över publiceringen för hela högskolan och för varje institution.
#Samma urval som verksahetsuppföljningen, vilket är något snävare än ÅR. 
#Publikationstyperna som i ÅR.
#ÖSS
#

library(tidyverse)

source('/home/shub/src/common/lib/sh_parameters.R')
source('/home/shub/src/common/lib/sh_diva_bibliometrics_functions.R')

n_issn <- read.csv(file="/home/shub/assets/nsd.issn.csv",
                   header=TRUE,
                   sep=";",
                   na.strings = c("", "NA"),
                   stringsAsFactors = FALSE,
                   encoding = "latin1")

sh_archive_start("publicering_sh_2015_2019")

diva <- read_csv(file="/home/shub/assets/diva/diva_researchpubl_sh_latest.csv")
diva <- diva %>% filter(between(Year, 2015, 2019))

diva$JournalISSN[is.na(diva$JournalISSN)] <- 0L
diva$JournalEISSN[is.na(diva$JournalEISSN)] <- 0L

# OSS ---------------------------------------------------------------------
# Lägg till kolumn för Östersjöstiftelsen som finansiär TRUE/FALSE
diva <- funder_oss(diva)


# Hela SH -----------------------------------------------------------------

publ_sh <- diva %>% 
  filter(PublicationType == "Artikel i tidskrift"|PublicationType == "Artikel, forskningsöversikt" |
    PublicationType == "Kapitel i bok, del av antologi" |PublicationType == "Bok" |PublicationType == "Konferensbidrag") %>%
  filter(ContentType!="Övrig (populärvetenskap, debatt, mm)") %>%
  filter((is.na(Status))|Status=="published") %>%
  filter(is.na(PublicationSubtype)|PublicationSubtype == "publishedPaper")%>%
  mutate(nsd = ((JournalISSN %in% n_issn$`Print.ISSN`)|(JournalEISSN %in% n_issn$`Online.ISSN`)))

publ_sh$PublicationType <- recode(publ_sh$PublicationType,
                                 "Artikel i tidskrift" = "Artiklar i tidskrift",
                                 "Artikel, forskningsöversikt" = "Artiklar i tidskrift",
                                 "Kapitel i bok, del av antologi" = "Artiklar i antologi",
                                 "Bok" = "Monografier",
                                 "Konferensbidrag" = "Publicerade konferensbidrag")

publ_sh_tabell <- publ_sh %>%
  group_by(PublicationType) %>% 
  count(Year) %>%
  spread(Year, n)


# Institutionerna ---------------------------------------------------------------------
#En tabell för varje institution. Lägg till institutionsnamn och slå ihop
sam <- publ_sh %>% 
  filter_orgs(sam)%>%
  group_by(PublicationType) %>% 
  count(Year) %>%
  spread(Year, n)
  
sam["InstName"] <- "ISV"
sam <- sam %>% unite(PublicationType, PublicationType, InstName, sep=": ")

hs <- publ_sh %>% 
  filter_orgs(hs)%>%
  group_by(PublicationType) %>% 
  count(Year) %>%
  spread(Year, n)

hs["InstName"] <- "IHS"
hs <- hs %>% unite(PublicationType, PublicationType, InstName, sep=": ")

ikl <- publ_sh %>% 
  filter_orgs(ikl)%>%
  group_by(PublicationType) %>% 
  count(Year) %>%
  spread(Year, n)

ikl["InstName"] <- "IKL"
ikl <- ikl %>% unite(PublicationType, PublicationType, InstName, sep=": ")

nmt <- publ_sh %>% 
  filter_orgs(nmt)%>%
  group_by(PublicationType) %>% 
  count(Year) %>%
  spread(Year, n)

nmt["InstName"] <- "NMT"
nmt <- nmt %>% unite(PublicationType, PublicationType, InstName, sep=": ")


# OSS publikationer ---------------------------------------------------------------

oss <- publ_sh %>% 
  filter(oss == TRUE)%>%
  group_by(PublicationType) %>% 
  count(Year) %>%
  spread(Year, n)

oss["InstName"] <- "ÖSS"
oss <- oss %>% unite(PublicationType, PublicationType, InstName, sep=": ")


# Språk -------------------------------------------------------------------

publ_lang <- publ_sh %>%
  group_by(Language) %>%
  count(Year) %>%
  spread(Year, n)

publ_lang[is.na(publ_lang)] <- 0L

# Avslut ------------------------------------------------------------------

publ_inst_tabell <- bind_rows(publ_sh_tabell, hs, ikl, nmt, sam, oss)
publ_inst_tabell[is.na(publ_inst_tabell)] <- 0L

write_csv(publ_inst_tabell, "SH_publ_2015_2019.csv")
write_csv(publ_lang, "SH_publ_lang.csv")

sh_archive_resource("SH_publ_2015_2019.csv")
sh_archive_resource("SH_publ_lang.csv")
sh_archive_df(publ_sh, "Medräknade_publikationer")
sh_archive_df(diva, "Diva_rådata")
sh_archive_end()
