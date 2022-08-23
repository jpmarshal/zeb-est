## Combine zebra data sets: Access DB + zeb locs from QGIS

library(tidyverse)
library(here)

zebEncs.mdb <- read_csv(here('Data', 'ZebEncs_AccDB.csv'))
zebEncs.qgis <- read_csv(here('Data', 'zebraLocsFromQGIS.csv'))

zeb.coords <- select(zebEncs.qgis, EncID, Xzeb = xzeb, Yzeb = yzeb)

zebEncs <- left_join(zebEncs.mdb, zeb.coords, key = 'EncID')
write.csv(zebEncs, file = here('Data', 'ZebEncsCombined.csv'))
