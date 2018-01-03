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
#' cod_municipios_16 <- cod_municipios_16 %>% mutate(INECodMuni = paste0(CPRO, CMUN)) #- Hay 8125 municipios.
#' cod_provincias <- cod_provincias %>% select(-CODAUTO) #- la quito xq sino se duplicaria
#' cod_INE_muni_pjp <-  left_join(cod_municipios_16, cod_provincias, by = "CPRO")
#'
#'
#' @format A data frame with 8125 rows and 11 variables:
#' \itemize{
#'   \item INECodCCAA: Código de CCAA
#'   \item INECodProv: Código de la provincia
#'   \item CMUN: Código del municipio (es del INE, pero sin el codigo de la Provincia no es útil)
#'   \item DC: Código de control
#'   \item NombreMuni: Nombre del municipio
#'   \item INECodMuni: Código de provincia + Código municipio. Es el que usa el INE muchas veces (5 digitos)
#'   \item NombreCCAA: Nombre de la CCAA
#'   \item NombreProv: Nombre de la provincia
#'   \item INENumMuni: número del municipio (as.integer(INECodMuni))
#'   \item INENumProv: número de la provincia (as.integer(INECodProv))
#'   \item INENumCCAA: número de la CCAA (as.integer(INECodCCAA))
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
#'   \item INECodMuni: codigo del municipio [tiene 5 dígitos; cod_prov+cod_muni]
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




#' padron_15_total_x_nac.rda
#'
#' Datos de poblacion (por nacionalidad) para el total de Spain
#' datos procedentes del Padron de 2015
#'
#' @format Es una tibble, con 114 rows y 4 variables
#' \itemize{
#'   \item pais_nacimiento:
#'   \item municipios: en este df esta v. es inutil xq los datos son para el total nacional, pero lo dejo
#'   \item sexo: [Total, Hombre, Mujer]
#'   \item value: nº de personas (integer)
#' }
#'
#'
"padron_15_total_x_nac"




#' padron_15_x_nac.rda
#'
#' Datos de poblacion (por nacionalidad) para cada MUNICIPIO
#' datos procedentes del Padron de 2015
#' las v. INECodMuni y NombreMuni salen de separar la v. "municipios"
#' df_x <- df_x %>% separate(municipios, into= c("INECodMuni", "NombreMuni"), by = "-", extra = "merge")
#'
#' @format Es una tibble, con 925.566 rows y 5 variables
#' \itemize{
#'   \item pais_nacimiento:
#'   \item INECodMuni: Código de provincia + Código municipio. Es el que usa el INE muchas veces
#'   \item NombreMuni: nombre del municipio
#'   \item sexo: [Total, Hombre, Mujer]
#'   \item value: nº de personas (integer)
#' }
#'
#'
"padron_15_x_nac"



#' padron_15_x_edad_5.rda
#'
#' Datos de poblacion (por quinquenios de edad) para cada MUNICIPIO
#' datos procedentes del Padron de 2015
#' las v. INECodMuni y NombreMuni salen de separar la v. "municipios"
#' df_x <- df_x %>% separate(municipios, into= c("INECodMuni", "NombreMuni"), by = "-", extra = "merge")
#'
#' @format Es una tibble, con 535.854 rows y 5 variables
#' \itemize{
#'   \item edad_5: grupo de edad (quinquenios)
#'   \item INECodMuni: Código de provincia + Código municipio. Es el que usa el INE muchas veces
#'   \item NombreMuni: nombre del municipio
#'   \item sexo: [Total, Hombre, Mujer]
#'   \item value: nº de personas (integer)
#' }
#'
#'
"padron_15_x_edad_5"



#' padron_15_x_edad_3g.rda
#'
#' Datos de poblacion (3 grupos de edad + el Total) para cada MUNICIPIO
#' datos procedentes del Padron de 2015
#' las v. INECodMuni y NombreMuni salen de separar la v. "municipios"
#' df_x <- df_x %>% separate(municipios, into= c("INECodMuni", "NombreMuni"), by = "-", extra = "merge")
#'
#' @format Es una tibble, con 292.284 rows y 6 variables
#' \itemize{
#'   \item edad_3g: grupo de edad (3+1 grupo)(Total [0-16[, [16-65[  y 65 o mas
#'   \item nacionalidad: Total, españoles, extranjeros
#'   \item INECodMuni: Código de provincia + Código municipio. Es el que usa el INE muchas veces
#'   \item NombreMuni: nombre del municipio
#'   \item sexo: [Total, Hombre, Mujer]
#'   \item value: nº de personas (integer)
#' }
#'
#'
"padron_15_x_edad_3g"





#' padron_15_x_nac_res.rda
#'
#' Datos de poblacion por relacion entre residencia y nacimineto (9 grupos)
#' datos procedentes del Padron de 2015
#' las v. INECodMuni y NombreMuni salen de separar la v. "municipios"
#' df_x <- df_x %>% separate(municipios, into= c("INECodMuni", "NombreMuni"), by = "-", extra = "merge")
#'
#' @format Es una tibble, con 219.213 rows y 5 variables
#' \itemize{
#'   \item res_nac: 8 gruppos + Total (x residencia y nacimineto)p.ej:Misma Comunidad Autónoma. Misma Provincia
#'   \item INECodMuni: Código de provincia + Código municipio. Es el que usa el INE muchas veces
#'   \item NombreMuni: nombre del municipio
#'   \item sexo: [Total, Hombre, Mujer]
#'   \item value: nº de personas (integer)
#' }
#'
#'
"padron_15_x_nac_res"




#' df_PEN_2017.rda
#'
#' Hack del Plan Estadistico Nacional 2017
#' Los detalles en "./data-raw/script_hack_PEN_2017_v1.R"
#' Lo q si t has de acordar es que en 2017 habia 400 operaciones estadisticas
#' PERO q como aparte del code_PEN hay otro codigo (code_IOE)
#' pues por eso hay 474 filas pero solo 400 operaciones del PEN
#' o sea, hay 74 rows con la v. code_PEN = NA
#'
#' Hay mas variables de las que muestro (generalmente de organismos involucrados)
#'
#' @format Es una tibble, con unas 474 rows y 35 variables
#' \itemize{
#'   \item code_PEN: es el código de la operacion estadistica en el PEN (este es el GOOD)
#'   \item op_estadistica: el nombre de la operacion estadistica
#'   \item code_IOE: código INE del "inventario de operaciones estadisticas" Es otro codigo al del PEN
#'   \item code_PEN_filled: code_PEN rellenando los NA accordingly (pero no lo uses salvo q realmnete lo quieras)
#'   \item ppto_total: coste de la encuenta (solo 2 operaciones tienen 2 organismos financiadores)
#'   \item id_sector: id sector o tema
#'   \item sector: sector o tema
#'   \item id_ministerio: cada operacion esta adscrita a un Ministerio
#'   \item Ministerio: nombre del Ministerio
#'   \item org_ppto1: siglas del organismo que financia la operacion estadistica
#'   \item org_involu1: el primero de la lista de organismo involucrados en la encuesta (llega a ver hasta 12 organismos)
#' }
#'
#'
"df_PEN_2017"




#' df_PEN_2018.rda
#'
#' Hack del Plan Estadistico Nacional 2018
#' Los detalles en "./data-raw/script_hack_PEN_2018_v1.R"
#' Lo q si t has de acordar es que en 2018 habia 407 operaciones estadisticas
#' PERO q como aparte del code_PEN hay otro codigo (code_IOE)
#' pues por eso hay 483 filas pero solo 400 operaciones del PEN
#' o sea, hay 76 con la v. code_PEN = NA
#'
#' Hay mas variables de las que muestro (generalmente de organismos involucrados)
#'
#' @format Es una tibble, con unas 483 rows y 35 variables
#' \itemize{
#'   \item code_PEN: es el código de la operacion estadistica en el PEN (este es el GOOD)
#'   \item op_estadistica: el nombre de la operacion estadistica
#'   \item code_IOE: código INE del "inventario de operaciones estadisticas" Es otro codigo al del PEN
#'   \item code_PEN_filled: code_PEN rellenando los NA accordingly (pero no lo uses salvo q realmnete lo quieras)
#'   \item ppto_total: coste de la encuenta (solo 2 operaciones tienen 2 organismos financiadores)
#'   \item id_sector: id sector o tema
#'   \item sector: sector o tema
#'   \item id_ministerio: cada operacion esta adscrita a un Ministerio
#'   \item Ministerio: nombre del Ministerio
#'   \item org_ppto1: siglas del organismo que financia la operacion estadistica
#'   \item org_involu1: el primero de la lista de organismo involucrados en la encuesta (llega a ver hasta 12 organismos)
#' }
#'
#'
"df_PEN_2018"




#' listado_organismos_PEN.rda
#'
#' Listado de organismos en el Plan Estadistico Nacional (estan en un apendice)
#' Los detalles en "./data-raw/script_hack_PEN_2018_v1.R"
#'
#' @format Es una tibble, con unas 35 rows y 2 variables
#' \itemize{
#'   \item sigla_org: siglas del organismo (BANESP)
#'   \item name_org: nombre del organismo (Banco de España)
#' }
#'
#'
"listado_organismos_PEN"
