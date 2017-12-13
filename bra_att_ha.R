#kommandon som jag har användning för

#Hämta fil på servern
diva <- read_csv(file="/home/shub/assets/diva/diva_researchpubl_sh_df_latest.csv", header = TRUE)


#ändra namn på kolumner
plyr::rename(utbildningsvet, c("FridaLevel" = "NorskaListan", "ISI" = "WoS"))

#Slå ihop publikationstyper genom att byta namn på värden
divaAR$PublicationType <- dplyr::recode(divaAR$PublicationType,
                                        "Artikel i tidskrift" = "Artiklar i tidskrift",
                                        "Artikel, forskningsöversikt" = "Artiklar i tidskrift",
                                        "Artikel, recension" = "Artiklar i tidskrift",
                                        "Kapitel i bok, del av antologi" = "Artiklar i antologi",
                                        "Doktorsavhandling, monografi" = "Doktorsavhandlingar",
                                        "Doktorsavhandling, sammanläggning" = "Doktorsavhandlingar",
                                        "Licentiatavhandling, monografi" = "Licentiatavhandlingar",
                                        "Licentiatavhandling, sammanläggning" = "Licentiatavhandlingar",
                                        "Bok" = "Monografier",
                                        "Konferensbidrag" = "Publicerade konferensbidrag",
                                        "Rapport" = "Rapporter")


#Få med rader med NA
divaAR <- divaAR %>% filter((is.na(Status))|Status=="published")

#Endast poster med PMID
pubmed <- diva %>% subset(PMID!="")

#De aktuella kolumnerna sorterat fallande efter år
pubmed <- pubmed %>% select(Title, Year, Urls, DOI, PMID) %>%
  arrange(desc(Year))

write.csv(pubmed, file="PubMed")