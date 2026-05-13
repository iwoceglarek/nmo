# Program wczytujący dane o miastach z GeoNames
#
# Źródło danych:
# GeoNames geographical database
# https://download.geonames.org/export/dump/

column_names  <- c(
  "geonameid", "name", "asciiname", "alternatenames",
  "latitude", "longitude", "feature_class", "feature_code",
  "country_code", "cc2", "admin1_code", "admin2_code",
  "admin3_code", "admin4_code", "population",
  "elevation", "dem", "timezone", "modification_date"
)

data  <- read.table(
  "PL/PL.txt",
  sep = "\t",
  header = FALSE,
  quote = "",
  comment.char = "",
  col.names = column_names ,
  stringsAsFactors = FALSE,
  encoding = "UTF-8"
)

pl_locations <- subset(
  data,
  feature_class == "P" & feature_code %in% c("PPL", "PPLA", "PPLA2", "PPLA3", "PPLC"),
  select = c(name, longitude, latitude)
)

pl_locations <- pl_locations[!duplicated(pl_locations$name),]

rm(column_names , data)
