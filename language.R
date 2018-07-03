#
#
# Publicationsspråk SH
#
#

library(tidyverse)

source('/home/shub/src/common/lib/sh_parameters.R')
source('/home/shub/src/common/lib/sh_diva_bibliometrics_functions.R')

diva <- read_csv("/home/shub/assets/diva/diva_researchpubl_sh_latest.csv")
diva <- diva %>% filter(between(Year, 2013, 2017))

language_pub <- diva %>%
  filter(ContentType %in% content_type[c("a", "b")]) %>%
  filter(PublicationType %in% publication_type[c("a", "b", "d", "g")]) %>%
  group_by(PublicationType, Year) %>%
  count(Language) %>%
  spread(Year, n) #Borde konferensbidrag vara med
