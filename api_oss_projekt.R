library(tidyverse)
library(httr)
library(jsonlite)

projektposter <- GET("http://diva-portal.org/smash/api/project/swecris?query=funderOrgNumber:802400-4155")



status_code(projektposter) # kontrollerar statuskod för HTTP, 200 om allt är korrekt

headers(projektposter) #kontrollerar formatet för filen, json eller xml
names(projektposter)

glimpse(projektposter) # ser kolumnrubriker

str(content(projektposter))

projekt_parsed <- content(projektposter, as="text") %>% fromJSON()
projekt_parsed$publications
projekt_parsed$count


alla_projekt_sh <- GET("http://diva-portal.org/smash/api/project/swecris?query=domain:sh")
status_code(alla_projekt_sh)
headers(alla_projekt_sh)
glimpse(alla_projekt_sh)

str(content(alla_projekt_sh))
alla_projekt_parsed <- content(alla_projekt_sh, as="text") %>% fromJSON()
