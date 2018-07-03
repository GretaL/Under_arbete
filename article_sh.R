#Artiklar Scoups

library(tidyverse)

source('/home/shub/src/common/lib/sh_parameters.R')
source('/home/shub/src/common/lib/sh_diva_bibliometrics_functions.R')

sh_archive_start("Öppen publicering")

diva <- read_csv("/home/shub/assets/diva/diva_author_sh_latest.csv")

diva <- diva %>% filter(between(Year, 2013, 2017))

diva_art <- diva %>%
  select(PID, Name.x, OrganisationIds, PublicationType, ContentType, Language, Journal, JournalISSN, JournalEISSN, Status, Year, ScopusId, ISI) %>%
  filter(ContentType %in% content_type[c("a", "b")]) %>%
  filter(PublicationType %in% publication_type[c("a", "b")]) #lägg in filter för status


#Ta ut orgnamn i filen

list_of_orgs <- regmatches(diva_art[["OrganisationIds"]], gregexpr("\\d+", diva_art[["OrganisationIds"]])) 
#gregexpr tar flera instanser per rad
list_of_orgs <- tibble(list_of_orgs)
diva_art_orgs <- bind_cols(diva_art, list_of_orgs)

inst <- tibble()

for (i in seq_along(inst_list)) {
  x <- diva_art_orgs %>%
    filter(map_lgl(list_of_orgs, ~any(inst_list[[i]] %in% .x))) %>%
    mutate(inst = names(inst_list[i]))
  inst <- bind_rows(inst, x)
}

amnen <- tibble()

for (i in seq_along(ämnen_list)) {
  x <- inst %>%
    filter(map_lgl(list_of_orgs, ~any(ämnen_list[[i]] %in% .x))) %>%
    mutate(ämne = names(ämnen_list[i]))
  amnen <- bind_rows(amnen, x)
}

centran <- tibble() #maris, scohost, enter: ska endast räknas med om författaren inte är dubbelaffilierad till ämne

for (i in seq_along(centra_list)) {
  x <- inst %>%
    filter(map_lgl(list_of_orgs, ~any(centra_list[[i]] %in% .x))) %>%
    mutate(centra = names(centra_list[i]))
  centran <- bind_rows(centran, x)
}

#För att ta fram de publikationer som inte ligger på ämnesnivå utan inst-nivå (inst_utan_amnen)
#samt kontrollera de som inte har inst (author_final_utan_inst)

#för att kunna joina behövs samma kolumner:
amnen_test <- select(amnen, -ämne) 
inst_test <- select(inst, -list_of_orgs, -inst)
centran_test <- select(centran, -list_of_orgs, -inst, -centra)

#Kontroll: vilka publikationer hör inte till institutioner? CBEES, biblioteket etc
authorfinal_utan_inst <- anti_join(diva_art, inst_test, by = "PID") #alla rader i authorfinal som inte finns i inst
#vilka publikationer har institution men inget ämne (dessa ska räknas med på inst-nivå)?
inst_utan_ämnen <- anti_join(inst, amnen_test, by = "PID") #alla rader i inst som inte finns i ämnen
#lägg in en ämneskolumn där "inget ämne anges" för att kunna bind_rows:
inst_utan_ämnen <- mutate(inst_utan_ämnen, ämne = "inget ämne")
#vilka publikationer hör endast till centrumbildningar? Notera att kombinationer över inst-gränser faller bort här
#som t ex måltidskunskap/enter
end_centra <- anti_join(centran_test, inst_test, by = "PID") #alla rader i centran_test som inte finns i inst_test

#lägg ihop de delar som ska räknas:
inst_och_amnen <- bind_rows(amnen, inst_utan_ämnen, end_centra)
inst_och_amnen <- select(inst_och_amnen, -list_of_orgs)

write.csv(diva_art, file="artiklar")
