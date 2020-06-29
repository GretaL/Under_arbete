#
#
#compare_publishing
#GL 200227
#Tabeller över publiceringen för hela högskolan och för varje institution.
#Komplement till uppfoljning_publicering_sh
#Samma urval som verksahetsuppföljningen, vilket är något snävare än ÅR. 
#Publikationstyperna som i ÅR.
#
#

library(tidyverse)

source('/home/shub/src/common/lib/sh_parameters.R')
source('/home/shub/src/common/lib/sh_diva_bibliometrics_functions.R')

sh_archive_start("compare_publishing")

diva <- read_csv(file="/home/shub/assets/diva/diva_researchpubl_sh_latest.csv")
diva <- diva %>% filter(between(Year, 2015, 2019))


# Hela SH -----------------------------------------------------------------

publ_sh <- diva %>% 
  filter(PublicationType == "Artikel i tidskrift"|PublicationType == "Artikel, forskningsöversikt" |
           PublicationType == "Kapitel i bok, del av antologi" |PublicationType == "Bok" |PublicationType == "Konferensbidrag") %>%
  filter(ContentType!="Övrig (populärvetenskap, debatt, mm)") %>%
  filter((is.na(Status))|Status=="published") %>%
  filter(is.na(PublicationSubtype)|PublicationSubtype == "publishedPaper")

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

publ_sh_tabell["UnivName"] <- "SH"
publ_sh_tabell <- publ_sh_tabell %>% unite(PublicationType, PublicationType, UnivName, sep=": ")

# Andra lärosäten ---------------------------------------------------------
# Utsökning i DiVA (csvall2). Begränsa år, organisation och innehållstyp. (Gärna mer för att minimera filen)
# Hur gör jag en generell, som ändrar namn?

univ_diva <- read_csv(file="mau_diva.csv")

univ <- univ_diva %>% 
  filter(PublicationType == "Artikel i tidskrift"|PublicationType == "Artikel, forskningsöversikt" |
           PublicationType == "Kapitel i bok, del av antologi" |PublicationType == "Bok" |PublicationType == "Konferensbidrag") %>%
  filter(ContentType!="Övrig (populärvetenskap, debatt, mm)") %>%
  filter((is.na(Status))|Status=="published") %>%
  filter(is.na(PublicationSubtype)|PublicationSubtype == "publishedPaper")

univ$PublicationType <- recode(univ$PublicationType,
                                  "Artikel i tidskrift" = "Artiklar i tidskrift",
                                  "Artikel, forskningsöversikt" = "Artiklar i tidskrift",
                                  "Kapitel i bok, del av antologi" = "Artiklar i antologi",
                                  "Bok" = "Monografier",
                                  "Konferensbidrag" = "Publicerade konferensbidrag")

univ <- univ %>%
  group_by(PublicationType) %>% 
  count(Year) %>%
  spread(Year, n)

univ["UnivName"] <- "Malmö universitet"
mau <- univ %>% unite(PublicationType, PublicationType, UnivName, sep=": ")

# Avslut ------------------------------------------------------------------

sh_compare_univ <- bind_rows(publ_sh_tabell, hig, kau, mau, miun)
sh_compare_univ[is.na(sh_compare_univ)] <- 0L

write_csv(sh_compare_univ, "SH_jämför_publ.csv")

sh_archive_resource("SH_jämför_publ.csv")
sh_archive_df(publ_sh, "Medräknade_publikationer_SH")
sh_archive_df(diva, "Diva_rådata")
sh_archive_end()
