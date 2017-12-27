library(tidyverse)
library(stringr)
library(readxl)
library(readr)
library(here)


#' (27-12-2017)-----------------------------------------------------

## Fichero INE con los códigos de las provincias y CCAA
cod_provincias <- read_excel(paste0(here(), "./data-raw/cod_provincias.xlsx"))
# devtools::use_data(cod_provincias) #- lo guargo


## fichero del INE con los municipios a 1-enero-2016
cod_municipios_16 <- read_excel(paste0(here(), "./data-raw/cod_municipios.xlsx"), skip = 1)
# devtools::use_data(cod_municipios_16) #- lo guargo

## Voy a fusionar cod_municipios_16 con cod_provincias
cod_municipios_16 <- cod_municipios_16 %>% mutate(INECodMuni = paste0(CPRO, CMUN))
cod_municipios_16 <- cod_municipios_16 %>% select(INECodMuni, NOMBRE, CPRO, DC)
## Hay 8125 municipios.
## Voy a fusionarlos con los códigos de las provincias y CCAA
cod_INE_muni_pjp <-  left_join(cod_municipios_16, cod_provincias, by = "CPRO")
# devtools::use_data(cod_INE_muni_pjp) #- lo guargo



#' (27-12-2017)-----------------------------------------------------

## Shapefiles de GADM database of Global Administrative Areas:  http://www.gadm.org/country
esp_adm0 <- readRDS(file = "./data-raw/spatial_ESP/GADM/ESP_adm0.rds")  #- shape GADM de ESPAÑA pais
# devtools::use_data(esp_adm0) #- lo guargo

#' (27-12-2017)-----------------------------------------------------
## Shapefiles de GADM database of Global Administrative Areas:  http://www.gadm.org/country
## No tiene los codigos INE pero lo voy a fusionar con "cod_provincias.rda"

esp_adm1 <- readRDS(file = "./data-raw/spatial_ESP/GADM/ESP_adm1.rds")  #- shape GADM de CCAA de SPAIN
# df_1 <- as.data.frame(esp_adm1, encoding = 'UTF-8', use_iconv = T)   #- 18 CCAA (Ceuta y Melilla van junats)

# lo voy a fusionar con: cod_provincias
load("./data/cod_provincias.rda")

#----- con esto veo las CCAA en las que no coincide el nombre de GADM con INE
# aa <- df_1 %>%  select(NAME_1) %>% distinct() %>% mutate(CCAA = NAME_1)
# bb <- cod_provincias %>% select(CODAUTO, CCAA) %>% distinct()
# cc <- dplyr::left_join(bb, aa )
# cc2 <- dplyr::full_join(bb, aa )

#- añado una columna a "esp_adm1" para añadirle los nombres de CCAA del INE y luego fusionar con "cod_provincias.rda"
esp_adm1@data$CCAA <- esp_adm1@data$NAME_1 #- duplico NAME_2 para arrglarlo con los codigos INE
esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Principado de Asturias"] <- "Asturias, Principado de"
esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Islas Baleares"] <- "Balears, Illes"
esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Islas Canarias"] <- "Canarias"
esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Comunidad Valenciana"] <- "Comunitat Valenciana"
esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Comunidad de Madrid"] <- "Madrid, Comunidad de"
esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Región de Murcia"] <- "Murcia, Región de"
esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Comunidad Foral de Navarra"] <- "Navarra, Comunidad Foral de"
esp_adm1@data$CCAA[esp_adm1@data$CCAA == "La Rioja"] <- "Rioja, La"
esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Ceuta y Melilla"] <- "Ceuta"  #- MAL, xq son los ines de Ceuta y Melilla

# Esta el Pb de que en GADM Ceuta y melilla estan juntas (deben tener un unico Shapefile para las 2)

aa <- cod_provincias %>% select(CODAUTO, CCAA) %>% distinct()  #- 19 xq esta Ceuta y Melilla
esp_adm1@data <- dplyr::left_join(esp_adm1@data, aa, by = c("CCAA" = "CCAA") )  #-
esp_adm1@data <-  esp_adm1@data %>% select(CODAUTO, CCAA, everything())
#devtools::use_data(esp_adm1) #- lo guargo


#' (27-12-2017)-----------------------------------------------------
## Shapefiles de GADM database of Global Administrative Areas:  http://www.gadm.org/country
## No tiene los codigos INE pero lo voy a fusionar con "cod_provincias.rda"

esp_adm2 <- readRDS(file = "./data-raw/spatial_ESP/GADM/ESP_adm2.rds")  #- shape GADM de PROVINCIAS de SPAIN
# df_2 <- as.data.frame(esp_adm2, encoding = 'UTF-8', use_iconv = T)   #- 56 provincias

# lo voy a fusionar con: cod_provincias
load("./data/cod_provincias.rda")  #- 52 provincias (se repiten Álava, La Rioja, Zaragoza y Santa Cruz de Tenerife)
# xq se repiten esas 4 provincias? tienen distinto shape? No lo sé

#----- con esto veo las CCAA en las que no coincide el nombre de GADM con INE
# aa <- df_2 %>%  select(NAME_2) %>% distinct() %>% mutate(PROVINCIA = NAME_2)
# bb <- cod_provincias %>% select(PROVINCIA, CPRO) %>% distinct()
# cc <- dplyr::left_join(bb, aa )
# cc2 <- dplyr::full_join(bb, aa )


esp_adm2@data$PROVINCIA <- esp_adm2@data$NAME_2 #- duplico NAME_2 para arrglarlo con los codigos INE
esp_adm2@data$PROVINCIA[esp_adm2@data$PROVINCIA == "Álava"] <- "Araba/Álava"
esp_adm2@data$PROVINCIA[esp_adm2@data$PROVINCIA == "Alicante"] <- "Alicante/Alacant"
esp_adm2@data$PROVINCIA[esp_adm2@data$PROVINCIA == "Baleares"] <- "Balears, Illes"
esp_adm2@data$PROVINCIA[esp_adm2@data$PROVINCIA == "Castellón"] <- "Castellón/Castelló"
esp_adm2@data$PROVINCIA[esp_adm2@data$PROVINCIA == "A Coruña"] <- "Coruña, A"
esp_adm2@data$PROVINCIA[esp_adm2@data$PROVINCIA == "Guipúzcoa"] <- "Gipuzkoa"
esp_adm2@data$PROVINCIA[esp_adm2@data$PROVINCIA == "La Rioja"] <- "Rioja, La"
esp_adm2@data$PROVINCIA[esp_adm2@data$PROVINCIA == "Las Palmas"] <- "Palmas, Las"
esp_adm2@data$PROVINCIA[esp_adm2@data$PROVINCIA == "Valencia"] <- "Valencia/València"
esp_adm2@data$PROVINCIA[esp_adm2@data$PROVINCIA == "Vizcaya"] <- "Bizkaia"

#- fusiono con los codigos INE de provincias
esp_adm2@data <- dplyr::left_join(esp_adm2@data, cod_provincias, by = c("PROVINCIA" = "PROVINCIA") )  #-
# df_22 <- as.data.frame(esp_adm2, encoding = 'UTF-8', use_iconv = T)   #- 56 prov (19 variables)
esp_adm2@data <-  esp_adm2@data %>% select(CPRO, PROVINCIA, CODAUTO, CCAA, everything())
#devtools::use_data(esp_adm2) #- lo guargo

#' (27-12-2017)-----------------------------------------------------
## Shapefiles de GADM database of Global Administrative Areas:  http://www.gadm.org/country
## No tiene los codigos INE pero lo voy a fusionar con "cod_provincias.rda"

esp_adm3 <- readRDS(file = "./data-raw/spatial_ESP/GADM/ESP_adm3.rds")  #- shape GADM de COMARCAS de SPAIN
# df_3 <- as.data.frame(esp_adm3, encoding = 'UTF-8', use_iconv = T)   #- 369 rows de 16 columnas
# ¿xq hay 369 comarcas, si realmentemuchos tienen NAME_3 = %na?
# No lo arreglo, pero lo guardo
#devtools::use_data(esp_adm3) #- lo guargo



#' (27-12-2017)-----------------------------------------------------
## Shapefiles de GADM database of Global Administrative Areas:  http://www.gadm.org/country
## No tiene los codigos INE pero lo voy a fusionar con "cod_INE.rda"

esp_adm4 <- readRDS(file = "./data-raw/spatial_ESP/GADM/ESP_adm4.rds")  #- shape GADM de COMARCAS de SPAIN
# df_4 <- as.data.frame(esp_adm4, encoding = 'UTF-8', use_iconv = T)   #- 8302 y 17 columnas
# load("./data/cod_INE_muni_pjp.rda")  #- 8125 municipios
#- Nada, no se puden unir, hay mas de 1000 municipios con nombre diferentes,
#- casi todos por la posicion del articulo
# No lo arreglo, pero lo guardo
# devtools::use_data(esp_adm4) #- lo guargo




#' (27-12-2017)-----------------------------------------------------
## Shapefiles del CNIG/INE: Municipios
library(rgdal)
municipios_CNIG <- readOGR(dsn = "./data-raw/spatial_ESP/Municipios2011_ETRS89_LAEA", layer = "Municipios2011_ETRS89_LAEA", encoding = 'UTF-8', use_iconv = TRUE)
municipios_CNIG_df <- as.data.frame(municipios_CNIG, encoding = 'UTF-8', use_iconv = T)   #- 8.116 municipios
# devtools::use_data(municipios_CNIG) #- lo guargo

#' (27-12-2017)-----------------------------------------------------
## Shapefiles del CNIG/INE: Provincias
library(rgdal)
provincias_CNIG <- readOGR(dsn = "./data-raw/spatial_ESP/Provincias2011_ETRS89_LAEA", layer = "Provincias2011_ETRS89_LAEA", encoding = 'UTF-8', use_iconv = TRUE)
provincias_CNIG_df <- as.data.frame(provincias_CNIG, encoding = 'UTF-8', use_iconv = T)   #- 52 provincias, 10 variables
# devtools::use_data(provincias_CNIG) #- lo guargo

#' (27-12-2017)-----------------------------------------------------
## Shapefiles del CNIG/INE: CCAA
library(rgdal)
CCAA_CNIG <- readOGR(dsn = "./data-raw/spatial_ESP/CCAA2011_ETRS89_LAEA", layer = "CCAA2011_ETRS89_LAEA", encoding = 'UTF-8', use_iconv = TRUE)
CCAA_CNIG_df <- as.data.frame(CCAA_CNIG, encoding = 'UTF-8', use_iconv = T)   #- 18 CCAA, 7 variables
# devtools::use_data(CCAA_CNIG) #- Ceuta y melilla van JUNTAS (la 18 CCAA)


