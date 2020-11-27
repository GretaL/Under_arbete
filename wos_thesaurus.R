#
#
#
# gl 201125
# Skript att städa adresser i WoS-data
# 
#

library(tidyverse)

names(master_thesaurus) <- c("label", "replace.by")

#Gör egen fil med enbart aktuell kolumn
wosdata <- read.delim(file="wos.tsv", header = TRUE, sep = "\t", encoding = "UTF-8", 
                      na.strings=c("","NA"), stringsAsFactors = FALSE) 

wosdata$C1 <- gsub('\\[.*?\\]', '', wosdata$C1)

label <- strsplit(wosdata$C1, ";")  #Delar celler i kolumnen Affiliations som har flera affilieringar (separerade med ;)
label <- unlist(label) #Gör varje tidigare ;-separerad affiliering till ett element i listan
label <- unique(label) #Tar bort dubbletter

label <- strsplit(label, ",") #Bättra att göra detta i excel?
label <- unlist(label) #Ändra.Ta bort, inte in i listan.
label <- unique(label)

temp_table <- as.data.frame(label, stringsAsFactors=FALSE, row.names=NULL) #Gör en ny tabell, andra kolumnen kommer att skapas mha vektorvärdena nedan



label <- temp_table[!(temp_table$label %in% master_thesaurus$label),] #Ta bort rader där affiliations finns i masterthesaurus
temp_table <- as.data.frame(label, stringsAsFactors=FALSE, row.names=NULL) #Eftersom föregående rad gör om tabellen till vektor

for(i in 1:length(temp_table$label)){
  temp_table$extract[i] <- str_extract(temp_table$label[i], "\\s*University West|\\s*University College|\\s*University Med.*|\\sUniversity Med*|\\s*University\\sof\\s\\w*|\\s*\\w*\\sUniver[a-z]{4}|\\s*Karolinska|\\s*högskola|\\s*Royal Institute of Technology|\\s*Blekinge Institute of Technology|\\s*KTH|\\s*International Business School|\\s*Stockholm School of Economics|\\s*Defence College|\\s*Swedish Museum of Natural History")
  
  #trimma kolumn extract genom att ta bort university, of och mellanslag.
  temp_table$extract[i] <- str_replace(temp_table$extract[i], "of", "")
  temp_table$extract[i] <- str_replace(temp_table$extract[i], "Univer[a-z]{4}", "")
  temp_table$extract[i] <- str_trim(temp_table$extract[i], side = c("both"))
}

temp_table <- temp_table[order(temp_table$extract),] #sortera på kolumn extract
temp_table$replace.by <- str_c(temp_table$extract, "univ", sep = " ") #sätt ihop två kolumner, library stringr ##Här det inte funkar?
temp_table$extract <- NULL #ta bort kolumn extract

write.csv(temp_table, "temp_table.csv", row.names = FALSE) # spara som csv-fil för manuell genomgång

#
#Standardisera namnvarianterna i Excel. Spara som temp_table_excel.tsv (via Notepad, UTF-8).
#

part_of_thesaurus <- read.csv(file="temp_table_excel.tsv", header = TRUE, sep="\t", quote="", encoding = "UTF-8",
                              na.strings=c("","NA"))

master_thesaurus_säkerhet <- master_thesaurus #gör en säkerhetskopia
master_thesaurus <- rbind(master_thesaurus, part_of_thesaurus, deparse.level = 0) #klistra in deltesaurus i masterthesaurus
master_thesaurus <- unique(master_thesaurus) #ta bort dubletter

names(master_thesaurus) <- c("label", "replace by") #ändra kolumntitlar till vosviewer standard

write.csv(master_thesaurus, "master_thesaurus.csv", row.names = FALSE) #Kvar att göra för att det ska bli en klar VOS-viewer thesaurus-fil: 
#Spara via notepad som tsv-textfil.
