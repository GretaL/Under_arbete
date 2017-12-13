#Städa förlag. Kolla norska listan

library(tidyverse)
diva <- read_csv("/home/shub/assets/diva/diva_researchpubl_latest.csv")
diva_forlag <- diva %>%
  filter(PublicationType == "Bok" |PublicationType == "Kapitel i bok, del av antologi" |PublicationType == "Konferensbidrag" |PublicationType == "Samlingsverk (redaktörskap)" |PublicationType == "Proceeding (redaktörskap)") %>%
  filter(between(Year, 2014, 2017)) %>%
  count(Publisher) %>%
  arrange(Publisher)
