library(tidyverse)

source('/home/shub/src/common/lib/sh_parameters.R')
source('/home/shub/src/common/lib/sh_diva_bibliometrics_functions.R')

diva <- read_csv("DiVA_rådata_181001.csv")

inst_pub <- diva %>%
  filter_orgs(sam) %>%
  filter(between(Year, 2013, 2018))

inst_pub <- select(inst_pub, -(list_of_orgs)) 
write_csv(inst_pub, "publ_isv_181001.csv")

foretagsekonomi_art <- diva_art %>%
  filter_orgs(foretagsekonomi)
forvaltning_art <- diva_art %>%
  filter_orgs(forvaltning)
imer_art <- diva_art %>%
  filter_orgs(internationella_relationer)
journalistik_art <- diva_art %>%
  filter_orgs(journalistik)
nek_art <- diva_art %>%
  filter_orgs(nationalekonomi)
offentlig_ratt_art <- diva_art %>%
  filter_orgs(offentlig_ratt)
psykologi_art <- diva_art %>%
  filter_orgs(psykologi)
socialt_arbete_art <- diva_art %>%
  filter_orgs(socialt_arbete)
sociologi_art <- diva_art %>%
  filter_orgs(sociologi)
scohost_art <- diva_art %>%
  filter_orgs(scohost)
statsvetenskap_art <- diva_art %>%
  filter_orgs(statsvetenskap)

#här skulle behövas en loop
foretagsekonomi_art <- select(foretagsekonomi_art, -(list_of_orgs)) 
  write_csv(foretagsekonomi_art, "fek_181001.csv")
forvaltning_art <- select(forvaltning_art, -(list_of_orgs)) 
  write_csv(forvaltning_art, "forv_181001.csv")
journalistik_art <- select(journalistik_art, -(list_of_orgs)) 
  write_csv(journalistik_art, "jour_181001.csv")
nek_art <- select(nek_art, -(list_of_orgs)) 
  write_csv(nek_art, "nek_181001.csv")
offentlig_ratt_art <- select(offentlig_ratt_art, -(list_of_orgs)) 
  write_csv(offentlig_ratt_art, "off_181001.csv")
psykologi_art <- select(psykologi_art, -(list_of_orgs)) 
  write_csv(psykologi_art, "psyk_181001.csv")
socialt_arbete_art <- select(socialt_arbete_art, -(list_of_orgs)) 
  write_csv(socialt_arbete_art, "socarb_181001.csv")
sociologi_art <- select(sociologi_art, -(list_of_orgs)) 
  write_csv(sociologi_art, "soc_181001.csv")
scohost_art <- select(scohost_art, -(list_of_orgs)) 
  write_csv(scohost_art, "scohost_181001.csv")
statsvetenskap_art <- select(statsvetenskap_art, -(list_of_orgs)) 
  write_csv(statsvetenskap_art, "stat_181001.csv")

