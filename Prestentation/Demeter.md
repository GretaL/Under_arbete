Demeter R-esultatet
========================================================
author: Greta Linder & Camilla Hertil Lindelöw
date: 2017-12-07
autosize: true

<style>

.reveal .state-background {
  background: lightblue;
}

.reveal .slideContent h1 {
  font-size: 180px;
  color: blue;
}

.reveal h3 {
  font-size: 80px;
}

.reveal .slides section .slideContent h2 {
   font-size: 60px;
   font-weight: bold;
}

</style>

Bakgrund
========================================================

Behov av en mer effektiv och säker arbetsprocess för våra bibliometriska analyser.

Kompetenshöjande då det gäller datahantering. 

Möjligt att koppla ihop flera källor.

Projektets deltagare: Camilla, Greta och Jonas Ö.

Vi jobbar med
========================================================

## R Studio:
- Gratis programvara
- Installerat på en virtuell server hos Sunet, för att vi skall kunna göra uppdateringar själva
- Programmeringsspråket R

***

## GitHub:
- Södertörns högskolebibliotek https://github.com/SodertornHB
- För att kunna dela skript med andra

Vi har lärt oss genom att
=======================================================

- titta på tutorials på nätet

- läsa en bok och tillsammans göra övningar

- Jonas har hållit lektioner i server-kunskap

Skriptet kan se ut så här
========================================================


```r
library(tidyverse)
library(stringr)

diva <- read_csv(file = "/home/shub/assets/diva/diva_researchpubl_latest.csv")

ahead_of_print <- diva %>% 
  subset(Status == "aheadofprint") %>%
  select(PID, DOI) %>%
  transmute(PID, link = str_c("https://doi.org/", DOI))
```

Resultatet 
========================================================
Det går att skriva resultatet till en csv-fil.  
I R Markdown blandas den egna texten med skript och genererar en rapporter som html, pdf eller word.


|     PID|link                                            |
|-------:|:-----------------------------------------------|
| 1117907|https://doi.org/10.1016/j.indmarman.2017.06.002 |
| 1106422|https://doi.org/10.1017/S2045796017000233       |
| 1082801|https://doi.org/10.1080/17512786.2017.1299032   |
| 1088818|https://doi.org/10.1080/00036846.2017.1310999   |
| 1138673|https://doi.org/10.1177/1555412017710616        |
|  936151|https://doi.org/10.1080/13691457.2016.1255928   |
|  899311|https://doi.org/10.1080/13504622.2017.1320704   |
| 1135721|https://doi.org/10.1007/s40926-017-0061-2       |
| 1053021|https://doi.org/10.1016/j.destud.2017.07.002    |
| 1089329|https://doi.org/10.1007/s10646-017-1866-4       |
| 1143682|https://doi.org/10.1177/1461444817731924        |
| 1118912|https://doi.org/10.1080/00131857.2017.1343113   |
| 1160186|https://doi.org/10.1007/s11097-017-9544-9       |
| 1138283|https://doi.org/10.1080/10253866.2017.1361153   |
| 1144914|https://doi.org/10.1002/nvsm.1594               |
| 1033188|https://doi.org/10.1177/1350506816671162        |
| 1140725|https://doi.org/10.1111/bor.12281               |
| 1152832|https://doi.org/10.1002/wcc.500                 |
| 1055324|https://doi.org/10.1080/1461670X.2016.1251332   |
| 1072081|https://doi.org/10.1080/1523908X.2017.1286575   |
| 1106415|https://doi.org/10.1080/01416200.2017.1324759   |
| 1135059|https://doi.org/10.1080/09640568.2017.1339594   |
| 1146474|https://doi.org/10.1080/17405904.2017.1382382   |
| 1127974|https://doi.org/10.1007/s00248-017-1028-5       |
| 1054908|https://doi.org/10.1080/0950236X.2016.1256343   |
| 1120665|https://doi.org/10.1007/s11019-017-9786-x       |
| 1155042|https://doi.org/10.1080/09654313.2017.1391751   |
| 1135102|https://doi.org/10.1002/poi3.159                |
|  967463|https://doi.org/10.1016/j.ecss.2016.07.015      |
| 1082527|https://doi.org/10.1177/1362361316680497        |
| 1148742|https://doi.org/10.1177/1461444817731922        |
| 1161842|https://doi.org/10.1080/15700763.2017.1384503   |
| 1157789|https://doi.org/10.1016/j.indmarman.2017.10.001 |
| 1109644|https://doi.org/10.1177/2399654417707527        |
| 1076209|https://doi.org/10.1002/eet.1775                |
| 1098966|https://doi.org/10.1080/13603124.2017.1321785   |
| 1095187|https://doi.org/10.1080/13504630.2017.1310038   |
| 1143678|https://doi.org/10.1177/1461444817731920        |
| 1160179|https://doi.org/10.1080/17512786.2017.1392254   |
| 1106466|https://doi.org/10.1177/0192512116684345        |
| 1088096|https://doi.org/10.1080/1461670X.2017.1310628   |

GitHub
=======================================================
Södertörns högskolebibliotek https://github.com/SodertornHB 

Skripten är uppdelade i olika arkiv, som vem som helst kan ladda ner.

Fortsättning
=======================================================

- Underhålla och förbättra de skript vi avänder

- Se om andra områden inom biblioteket kan använda skript

- Underhålla servern

Slide
=======================================================
title: false


# Frågor?
