#
#URL utan text
#180723 GL
#

library(tidyverse)

diva <- read_csv("/home/shub/assets/diva/diva_researchpubl_latest.csv")

med_url <- diva %>%
  filter(!(is.na(Urls))) %>%
  select(PID, Urls, DOI, FreeFulltext)

#något med grep för att få bort bibl.sh.se/publikationer         