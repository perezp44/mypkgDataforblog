#' This file documents datasets
#'
#' cod_provincias.rda
#'
#' Codigos del INE para provincias y CCAA españolas
#'
#' @format A data frame with 52 rows and 4 variables:
#' \itemize{
#'   \item CODAUTO: Código de CCAA
#'   \item CCAA: Nombre de la CCAA
#'   \item CPRO: Código de la provincia
#'   \item PROVINCIA: Nombre de la provincia
#' }
#'
#'
#' @source \url{http://www.ine.es}
"cod_provincias"


#' cod_municipios_16.rda
#'
#' Codigos del INE para municipios españoles a 1 enero 2016
#'
#' @format A data frame with 8125 rows and 4 variables:
#' \itemize{
#'   \item CODAUTO: Código de CCAA
#'   \item CPRO: Código de la provincia
#'   \item CMUN: Código del municipio
#'   \item DC: Código de control
#'   \item NOMBRE: Nombre del municipio
#' }
#'
#'
#' @source \url{http://www.ine.es}
"cod_municipios_16"




#' cod_INE_muni_pjp.rda
#'
#' Codigos del INE para municipios españoles a 1 enero 2016
#' tb tiene los codigos de provincia y CCAA
#' los he unido yo asi:
#'
#' cod_municipios_16 <- cod_municipios_16 %>% mutate(INECodMuni = paste0(CPRO, CMUN))
#' cod_municipios_16 <- cod_municipios_16 %>% select(INECodMuni, NOMBRE, CPRO, DC)
#' cod_INE_muni_pjp <-  left_join(cod_municipios_16, cod_provincias, by = "CPRO")
#'
#'
#' @format A data frame with 8125 rows and 7 variables:
#' \itemize{
#'   \item INECodMuni: Código de provincia + Código municipio. Es el que usa el INE muchas veces
#'   \item NOMBRE: Nombre del municipio
#'   \item CPRO: Código de la provincia
#'   \item DC: Código de control
#'   \item CODAUTO: Código de CCAA
#'   \item CCAA: Nombre de la CCAA
#'   \item PROVINCIA: Nombre de la provincia
#' }
#'
#'
#' @source \url{http://www.ine.es}
"cod_INE_muni_pjp"



#' esp_adm0.rda
#' Shapefiles de GADM database of Global Administrative Areas: COUNTRY level
#' http://www.gadm.org/country
#'
#' su df tiene 68 variables !! todas referidada a SPAIN (nombre en frances...)
#'
#'
#' @source \url{http://www.gadm.org/country}
"esp_adm0"





#' esp_adm1.rda
#'
#' Shapefiles de GADM database of Global Administrative Areas: CCAA
#' http://www.gadm.org/country
#'
#' Tiene un PB: Ceuta y Melilla estaban juntas, asi que le he asignado el Código
#' y el nombre de Ceuta; osea, el nombre "Ceuta" está asignado a un polygon que recoge
#' los limites de Ceuta y de melilla
#'
#' tb tiene los nombres y codigos  de las CCAA del INE xq los he añadido yo asín:
#' los he unido yo asi:
#'
#' esp_adm1 <- readRDS(file = "./data-raw/ESP_adm1.rds")  #- shape GADM de ESPAÑA pais
#' load("./data/cod_provincias.rda")
#' esp_adm1@data$CCAA <- esp_adm1@data$NAME_1 #- duplico NAME_2 para arrglarlo con los codigos INE
#' esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Principado de Asturias"] <- "Asturias, Principado de"
#' esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Islas Baleares"] <- "Balears, Illes"
#' esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Islas Canarias"] <- "Canarias"
#' esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Comunidad Valenciana"] <- "Comunitat Valenciana"
#' esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Comunidad de Madrid"] <- "Madrid, Comunidad de"
#' esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Región de Murcia"] <- "Murcia, Región de"
#' esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Comunidad Foral de Navarra"] <- "Navarra, Comunidad Foral de"
#' esp_adm1@data$CCAA[esp_adm1@data$CCAA == "La Rioja"] <- "Rioja, La"
#' esp_adm1@data$CCAA[esp_adm1@data$CCAA == "Ceuta y Melilla"] <- "Ceuta"  #- MAL, xq son los ines de Ceuta y Melilla
#'
#' @format Es Spatial Polygon, pero su df tiene 18 rows (CCAA) y 15 variables ellas
#' \itemize{
#'   \item CODAUTO: Código de CCAA (original del INE, fichero cod_provincias.rda)
#'   \item CCAA: Nombre de la CCAA (original del INE, fichero cod_provincias.rda)
#' }
#'
#'
#' @source \url{http://www.gadm.org/country}
"esp_adm1"



#' esp_adm2.rda
#'
#' Shapefiles de GADM database of Global Administrative Areas: PROVINCIAS
#' http://www.gadm.org/country
#'
#'
#' tb tiene los nombres y codigos de CCAA y PROVINCIAS del INE xq los he añadido yo asín:
#' los he unido yo asi:
#'
#'
#' @format Es Spatial Polygon, pero su df tiene 18 rows (CCAA) y 15 variables ellas
#' \itemize{
#'   \item CPRO: Código de la provincia (original del INE, fichero cod_provincias.rda)
#'   \item PROVINCIA: Nombre de la provincia  (original del INE, fichero cod_provincias.rda)
#'   \item CODAUTO: Código de CCAA (original del INE, fichero cod_provincias.rda)
#'   \item CCAA: Nombre de la CCAA (original del INE, fichero cod_provincias.rda)
#' }
#'
#'
#' @source \url{http://www.gadm.org/country}
"esp_adm2"



#' esp_adm3.rda
#'
#' Shapefiles de GADM database of Global Administrative Areas: COMARCAS
#' http://www.gadm.org/country
#'
#' @format Es Spatial Polygon, pero su df tiene 369 rows y 16 columnas
#' ¿xq hay 369 comarcas, si realmente muchos tienen NAME_3 = %na? Pues xq SI, molan las comarcas
#'
#' @source \url{http://www.gadm.org/country}
"esp_adm3"



#' esp_adm4.rda
#'
#' Shapefiles de GADM database of Global Administrative Areas: MUNICIPIOS
#' http://www.gadm.org/country
#'
#'
#' @format Es Spatial Polygon, pero su df tiene 8302 y 17 columnas
#' pero resulta que en el fichero del INE tengo 8125 municipios
#'
#' @source \url{http://www.gadm.org/country}
"esp_adm4"



#' municipios_CNIG.rda
#'
#' Shapefiles de municipios de CNIG
#' https://www.cnig.es/
#'
#' @format Es Spatial Polygon Dataframe, pero su df tiene 8116 y 13 columnas
#' pero resulta que en el fichero del INE tengo 8125 municipios
#' \itemize{
#'   \item NombreMuni: nombre del municipio
#'   \item INECodMuni: codigo del municipio [tiene 5 codigos; cod_prov+cod_muni]
#'   \item INENumMuni: número del municipio
#'   \item NombreProv:
#'   \item INECodProv:
#'   \item INENumProv:
#'   \item NombreCCAA:
#'   \item INECodCCAA:
#'   \item INENumCCAA:
#'   \item Area:
#'   \item Perimeter:
#'   \item X_Centroid:
#'   \item Y_Centroid:
#' }
#'
#'
#' @source \url{https://www.cnig.es/}
"municipios_CNIG"



#' provincias_CNIG.rda
#'
#' Shapefiles de PROVINCIAS de CNIG
#' https://www.cnig.es/
#'
#' @format Es Spatial Polygon Dataframe, pero su df tiene 52 y 10 columnas
#' \itemize{
#'   \item NombreProv: nombre provincia
#'   \item INECodProv: codigo provincia
#'   \item INENumProv: numero provincia
#'   \item NombreCCAA:
#'   \item INECodCCAA:
#'   \item INENumCCAA:
#'   \item Area:
#'   \item Perimeter:
#'   \item X_Centroid:
#'   \item Y_Centroid:
#' }
#'
#'
#' @source \url{https://www.cnig.es/}
"provincias_CNIG"



#' CCAA_CNIG.rda
#'
#' Shapefiles de CCAA de CNIG
#' https://www.cnig.es/
#'
#' @format Es Spatial Polygon Dataframe, pero su df tiene 18 y 7 columnas
#' \itemize{
#'   \item NombreCCAA: nombre CCAA
#'   \item INECodCCAA: codigo CCAA
#'   \item INENumCCAA: numero CCAA
#'   \item Area:
#'   \item Perimeter:
#'   \item X_Centroid:
#'   \item Y_Centroid:
#' }
#'
#'
#' @source \url{https://www.cnig.es/}
"CCAA_CNIG"





