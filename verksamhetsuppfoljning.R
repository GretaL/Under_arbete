#
#
#
#verksamhetsuppföljning
#180626 GL
#Sammanställning av högskolans vetenskapliga publikationer till AVMs verksamhetsuppföljning.
#Fortsättningen gjordes i excel. Utveckling: institutioner i klartext, tabell för hela högskolan
#och varje institution.
#
#
#


library(tidyverse)
source('/home/shub/src/common/lib/sh_diva_bibliometrics_functions.R')
sh_archive_start("Verksamhetsuppföljning")

#Läs in data från DiVA. En csv2 som redan är kombinerad med csvall2.
diva <- read_csv(file="/home/shub/assets/diva/diva_author_sh_latest.csv")
diva <- diva %>% filter(between(Year, 2013, 2017))

#De publikationer som skall ingå i sammanställningen
divaVU <- diva %>% 
  filter(!(PublicationType == "Samlingsverk (redaktörskap)"|PublicationType == "Proceedings (redaktörskap)" |PublicationType == "Övrigt" |PublicationType == "Artikel, recension")) %>%
  filter(ContentType!="Övrig (populärvetenskap, debatt, mm)") %>%
  filter((is.na(Status))|Status=="published") %>%
  filter(is.na(PublicationSubtype)|PublicationSubtype == "publishedPaper")

#Slå ihop publikationstyper genom att byta namn på värden
divaVU$PublicationType <- recode(divaVU$PublicationType,
                                 "Artikel i tidskrift" = "Artiklar i tidskrift",
                                 "Artikel, forskningsöversikt" = "Artiklar i tidskrift",
                                 "Kapitel i bok, del av antologi" = "Artiklar i antologi",
                                 "Doktorsavhandling, monografi" = "Doktorsavhandlingar",
                                 "Doktorsavhandling, sammanläggning" = "Doktorsavhandlingar",
                                 "Licentiatavhandling, monografi" = "Licentiatavhandlingar",
                                 "Licentiatavhandling, sammanläggning" = "Licentiatavhandlingar",
                                 "Bok" = "Monografier",
                                 "Konferensbidrag" = "Publicerade konferensbidrag",
                                 "Rapport" = "Rapporter")

#Spara i excel innan leverans
sh_archive_df(divaVU, "Medräknade_publikationer")
sh_archive_df(diva, "Diva_rådata")
sh_archive_end()
