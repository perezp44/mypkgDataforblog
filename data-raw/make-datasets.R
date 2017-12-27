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

