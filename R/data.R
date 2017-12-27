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






