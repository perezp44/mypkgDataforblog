#- Objetivo: Hackear el Plan Estadistico Nacional (PEN) 2017-2020 en .... 2018
#- Resulta que la informacion sobre el PEN solo esta disponible (al menos para mi) 
#- en ficheros .pdf y .xlm (perfecto si estuviera biene structurado pero no es el caso)
#- entonces se trata de sacar la informacion del PEN y ponerla en un dataframe
#- ¿Qué información hay? Pues hay 3 listados
#- 1) Listado de operaciones estadisticas por SECTOR o TEMA
#- 2) Listado de operaciones estadisticas por ORGANISMO encargado (este está muy liado)
#- 3) Listado de operaciones (con informacion sobre presupuesto y algo mas)

#-  #- AQUI ARREGLO EL FALLO (hay 2 fallos en el fichero de 2017)

#- biblio: parsing pdf's
#- https://www.r-bloggers.com/extracting-data-on-shadow-economy-from-pdf-tables/ (script para coger datos de un pdf)
#- https://itsalocke.com/blog/working-with-pdfs---scraping-the-pass-budget/
#- https://www.r-bloggers.com/release-open-data-from-their-pdf-prisons-using-tabulizer/
#- biblio: parsing xlm
#- https://towardsdatascience.com/web-scraping-tutorial-in-r-5e71fd107f32
#- https://lecy.github.io/Open-Data-for-Nonprofit-Research/Quick_Guide_to_XML_in_R.html

#- cargando librerias
library(pdftools)
library(scales)
library(stringr)
library(personal.pjp)
library(tidyverse)
library(rvest)

#- En realidad hay 3 documentos:
#- 1) el PEN 2017-2020 (http://www.boe.es/boe/dias/2016/11/18/pdfs/BOE-A-2016-10773.pdf)
#- 2) el PEN para 2017 (http://www.boe.es/boe/dias/2016/12/31/pdfs/BOE-A-2016-12607.pdf)
#- 3) el PEN para 2018 (http://www.boe.es/boe/dias/2017/12/29/pdfs/BOE-A-2017-15722.pdf)
#- Ademas cada pdf tiene asociado un archivo .xml; pero solo son útiles los de 2017 y 2018 
#- xq resulta q el .xml de 2017-2020 tiene la informacion en imagenes

#- primero me baje los 3 pdf y los 3 xml para poder trabajar en LOCAL
#- download pdf file 
# download.file("https://www.boe.es/boe/dias/2016/12/31/pdfs/BOE-A-2016-12607.pdf",  destfile = "./pdfs/plan_estadistico_nacional.pdf", mode = "wb") # - no se descarga bien
#- dowload XML file ()
# download.file("https://www.boe.es/diario_boe/xml.php?id=BOE-A-2016-12607",  destfile = "./pdfs/plan_estadistico_nacional.xml", mode = "wb") # - 
#- he guardado los links de descarga en: ./pdfs_2018/
#- Hay 3 documentos pdf: 1) El Plan 2017-2020 2) El plan para 2017 y 3) El plan para 2018
#- Tb hay 3 documentos XML, PERO solo 2 de ellos me valdran, xq el del Plan 2017-2020 en lugar de texto tiene imagenes. (NO PUEDE SER!!)


#---------------------------------------------- Voy a trabajar con los ficheros .xml


#- Plan estadistico nacional 2017-2020 (PEN_2017_2020)
#- pero resulta que no es texto, sino imagenes, asi q tendre q hacerlo como pdf (ya vorem)
# PEN_2017_2020 <- read_html("./pdfs_2018/BOE-A-2016-10773.xml") 


#---------------------------------------------- Me centro en PEN-2018    (2018)
#- 2017 (PEN_2017) vs 2018

#- si cambia algo respecto a l de 2017 lo pondre asi: (DIFIERE 2017-2018)
# 1) aa <- aa %>% filter(!(str_detect(linea, "N.º Prog.	Nombre de la operación")))  #- 434 rows (DIFIERE 2017-2018)
# 2) bb_Prog <- aa %>% filter((str_detect(linea, "NºIOE")))  #- 102 en 2018 vs. 99 en 2019 (DIFIERE 2017-2018)
# 3) ministerios <- aa %>% filter((str_detect(linea, "^MINISTE"))) #- En 2018 esta en Mayusculas (DIFIERE 2017-2018)
# 4) aa_resto <- aa %>% filter(!(str_detect(linea, "^MINISTE"))) #- quita las 12 lineas de ministerios (DIFIERE 2017-2018)
# 5) aa_resto <- aa_resto %>% filter(!(str_detect(linea, "NºIOE"))) #- 668 (DIFIERE 2017-2018)

#- En 2018 hay 407 operaciones vs. 400 en 2017

PEN_2018 <- read_html("./pdfs_2018/BOE-A-2017-15722.xml") 

#- tras inspección visual veo que el listado de operaciones estan en los nodos <p>
parrafos <- PEN_2018 %>% html_nodes('body') %>% 
                         html_nodes('documento') %>% 
                         html_nodes("p") 
#- extraigo el texto q hay en los nodos <p>
parrafos_txt <- parrafos %>% html_text() %>% as.data.frame()   #- 6315 rows, el de 2017 tenía 6085 rows

#- veo que el listado por temas esta en parrafos_txt(178:638) y ...
lista_x_temas <- parrafos_txt %>% slice(178:638)
lista_x_organismos <- parrafos_txt %>% slice(642:1440)
lista_operaciones <- parrafos_txt %>% slice(1445:6032) #- un listado de operaciones (con ppto)
lista_organismos <- parrafos_txt %>% slice(6069:6138)  #- un listado de organismos

#- faltaria las previsiones presupuestarias y el calendario de ejecucion (pero son imagenes!!)
rm(parrafos, parrafos_txt, PEN_2018)

#----------------------------------------  Antes de empezar, parseamos  la lista de Organismos

#- parsear listado de organismos
aa <- lista_organismos  #- 62 rows; por tanto 31 organismos
aa <- aa %>% set_names("linea")
aa <- aa %>% mutate(index_tmp = 1:n())
aa <- aa %>% mutate(is_even = if_else(index_tmp %% 2 == 0, "even", "odd") )
aa_even <- aa %>% filter(is_even == "even")  %>%  select(linea) %>% rename(name_org = linea)
aa_odd <- aa %>% filter(is_even != "even")  %>%  select(linea) %>% rename(sigla_org = linea)
df_org_ok <- bind_cols(aa_odd, aa_even)

df_org_ok <- df_org_ok %>% mutate(sigla_org = as.character(sigla_org)) %>% 
                                       mutate(name_org = as.character(name_org))
rm(aa, aa_even, aa_odd, lista_organismos)


#----------------------------------------  PRIMERO parseamos  la lista por SECTOR o TEMA

#- parsear el listado de estadisticas por temas (lista_x_temas)
aa <- lista_x_temas              #- 454 rows, el nombre es no estandar `.`
aa <- aa %>% set_names("linea")  #- renombro

aa <- aa %>% filter(!(str_detect(linea, "N.º Prog.	Nombre de la operación")))  #- 434 rows (DIFIERE 2017-2018)
aa <- aa %>% mutate(id_tmp = 1:n())  #- pongo un index

#- genero df con el listado de Sectores o temas
temas <- aa %>% filter(str_detect(linea, "Sector o tema:")) #- extraigo las rows con "Sector o tema:"
temas <- temas %>% rename(sector = linea)
temas <- temas %>% mutate(sector = str_replace_all(sector, "Sector o tema: ", ""))
temas <- temas %>% mutate(id_sector = 1:n()) %>% select(id_sector, everything()) #- 27 temas

#- genero indices para coger las operaciones estadisticas q caen dentro de cada Sector o tema
temas <- temas %>% mutate(n1 = id_tmp+1 )
temas <- temas %>% mutate(n2 = lead(id_tmp)-1) 
temas$n2[nrow(temas)] <- nrow(aa)  #- el segundo index(n2) del ultimo tema tengo que ponerlo a mano.
temas <- temas %>% select(-id_tmp)  #- quito el indice temporal
temas <- temas %>% map(str_trim, side = "both") %>% as.tibble() #- quita caracteres al final y al ppio

#- genero df con las operaciones estadisticas
operaciones <- aa %>% filter(!str_detect(linea, "Sector o tema:")) #- hay 400 operaciones
operaciones <- operaciones %>% map(str_trim, side = "both") %>% as.tibble() #- quita caracteres al final y ppio
operaciones <- operaciones %>% mutate(id_operaciones = 1:n()) %>% select(id_operaciones, everything())
operaciones <- operaciones %>% separate(linea, into = c("codigo_op_estadistica", "op_estadistica"), sep = 5)
operaciones <- operaciones %>% map(str_trim) %>% as.tibble() #- quita caracteres al final
operaciones <- operaciones %>% mutate(id_tmp = as.double(id_tmp))

#- generar los vectores con los indices de las operaciones para asignar tema a las operaciones
operaciones <- operaciones %>% mutate(id_sector = 777)
for (i in 1:nrow(temas)){
       lim_inferior  <- as.double(temas[i,3])
       lim_superior  <- as.double(temas[i,4])
       q_sector  <- as.double(temas[i,1])
   operaciones <- operaciones %>% mutate(id_sector = if_else(id_tmp >= lim_inferior,  q_sector, id_sector ))
}
operaciones <- operaciones %>% select(-id_tmp)


#- junto operaciones y temas por la variable "id_sector" y creo "df_temas_ok"
temas <- temas %>% mutate(id_sector = as.double(id_sector)) %>%  #- lo paso a numeros
                   select(id_sector, sector)
df_temas_ok <- right_join(operaciones, temas, by = "id_sector")

rm(i, lim_inferior, lim_superior, q_sector)
rm(aa, operaciones, temas, lista_x_temas)

#- arreglo "df_temas_ok"
df_temas_ok <- df_temas_ok %>% mutate(id_operaciones = as.numeric(id_operaciones))
df_temas_ok <- df_temas_ok %>% mutate(codigo_op_estadistica = as.numeric(codigo_op_estadistica))

#- cambio el nombre
df_estad_x_temas <- df_temas_ok
rm(df_temas_ok)


#----------------------------------------  SEGUNDO: parseamos el listado de operaciones por organismos
#- Hay varios problemas (al menos en 2017):
#- 1. Los organismos no los pone para cada operaciones sino que van por epigrafes; 
#- entonces solo estare seguro (para cada operacion) de cual es el primer y el ultimo organismo
#- para entender lo q digo ve al principio de la pp. 22 del pdf.
#- 2. HAY UN FALLLLOOOO: resulta que la operación estadistica Recaudacion Tributaria" cuyo verdader codigo es el 7528, 
#- en esta seccion en el BOE tiene asignado el codigo 7526, en lugar del de 7528 que es el q le correspone (mira el listado de operaciones)
#- lo arreglare más abajo con esta instrucción: numeros_2[3,1] <- 7528   #- AQUI ARREGLO EL FALLO
#- 3. Hay un "fallo" de formato que me complica la vida:
#- resulta q la operacion con código 7312 le falta el "-------" y me da pbs al identificar las operaciones, asi que:
#- para solucionarlo hago mas adelante:
#- dd_numeros <- dd_numeros %>% mutate(linea_n = str_replace_all(linea_n, "Estadística de Previsión Social Complementaria", "-------	Estadística de Previsión Social Complementaria")) #)
#------------------------------------------------------------------------------------------------------------

#- parsear el listado de estadisticas agrupados por organismos
#- voy a por la lista_x_organismos (operaciones agrupadas por organismos)
aa <- lista_x_organismos  #- 779 rows
aa <- aa %>% set_names("linea")
aa <- aa %>% map(str_trim, side = "both") %>% as.tibble() #- quita caracteres al final y ppio

aa <- aa %>% mutate(id_linea = 1:n())
bb_Prog <- aa %>% filter((str_detect(linea, "NºIOE")))  #- 102 en 2018 vs.99  (DIFIERE 2017-2018)
cc_Formada <- aa %>% filter((str_detect(linea, "Formada por:")))  #- 24 (= en 2017)
dd_numeros <- aa %>% filter( (str_detect(linea, "^[[:digit:]]" ) ))  #- 483 2018 vs. 474
dd_numeros <- dd_numeros %>% separate(linea, into = c("code", "linea_n"), sep = "\\W", extra = "merge" )  %>%    #- AQUI TRUCO
                     map(str_trim, side = "both") %>% as.tibble() #- AQUI TRUCO


#- arreglar el "fallo" de la operacion con código 7312. le falta el "------"
#- esa operacion acabara en el df "numeros_3"  #- AQUI ARREGLO EL FALLO
dd_numeros <- dd_numeros %>% mutate(linea_n = str_replace_all(linea_n, "Estadística de Previsión Social Complementaria", "-------	Estadística de Previsión Social Complementaria")) #)
#- EN LA LINEA de ARRIBA ARREGLO "fallo"


#- separar las operaciones en 3 grupos, segun tengan 2 codigos (IOE y el del plan o solo 1 (2 categorias)
numeros_1 <- dd_numeros %>% filter( (str_detect(linea_n, "^[[:digit:]]" ) ))  #- AQUI TRUCO
numeros_1 <- numeros_1 %>% separate(linea_n, into = c("code_1", "linea_n_1"), sep = "\\W", extra = "merge" )  %>%    #- AQUI TRUCO
  map(str_trim, side = "both") %>% as.tibble() #- AQUI TRUCO (non-word characteres)

numeros_2 <- dd_numeros %>% filter( (str_detect(linea_n, "^---" ) ))  #- AQUI TRUCO
numeros_2 <- numeros_2 %>% separate(linea_n, into = c("code_1", "linea_n_1"), sep = "\\s" , extra = "merge" )  %>%    #- AQUI TRUCO
  map(str_trim, side = "both") %>% as.tibble() #- AQUI TRUCO (\\s espacios y cosas blancas)

numeros_3 <- dd_numeros %>% filter( (str_detect(linea_n, "^[[:alpha:]]" ) ))  #- AQUI TRUCO
numeros_3 <- numeros_3 %>% rename(code_1 = code)
numeros_3 <- numeros_3 %>% mutate(code = NA) %>% select(code, everything())
numeros_3 <- numeros_3 %>% rename(linea_n_1 = linea_n)


#- La operacion "Recaudacion Tributaria" cuyo verdadero codigo es el 7528, 
#- en esta seccion en el BOE tiene puesto codigo 7526
#- esta en numeros_2, en la tercera row
# numeros_2[3,1] <- 7528   #- AQUI ARREGLO EL FALLO (en 2017, pero en 2018 ESTA BIEN)


#- agrupo las 3 categorias de operaciones (en f. de como tengan puestos los 2 codigos q hay en el listado x organismos)
numeros_ok <- bind_rows(numeros_1, numeros_2, numeros_3) 
numeros_ok <- numeros_ok %>%  mutate(id_linea = as.double(id_linea)) %>% arrange(id_linea)

#- un chequeo: numeros = numeros_1+ numeros_2+numeros_3   (deben sumar el nº de rows)
rm(bb_Prog, cc_Formada, dd_numeros, numeros_1, numeros_2, numeros_3)

#---------------- parsear los organismos el cplicaet xq esta raro
#- resulta que cada operacion tiene una linea por cada organismo involucrado, pero ademas siempre empeiza con el ministerio (aqunue no este)

#- saco los Ministerios ministerios                
#- ministerios <- aa %>% filter((str_detect(linea, "^Ministe"))) #- En 2017
ministerios <- aa %>% filter((str_detect(linea, "^MINISTE"))) #- En 2018 esta en Mayusculas

ministerios <- ministerios %>% mutate(id_ministerio = 1:n()) %>% select(id_ministerio, everything())

#- creo indices para poner a cada operacion el ministerio al q pertenece
ministerios <- ministerios %>% mutate(n1 = id_linea+1 )
ministerios <- ministerios %>% mutate(n2 = lead(id_linea)-1) 
ministerios$n2[nrow(ministerios)] <- nrow(aa)  #- el ultimo lo he de poner a mano

#- voy a poner a cada estadistica su ministerio
numeros_ok <- numeros_ok %>% mutate(id_ministerio = 777)  #- 
for (i in 1:nrow(ministerios)){
  lim_inferior  <- as.double(ministerios[i,3])
  lim_superior  <- as.double(ministerios[i,4])
  q_ministerio  <- as.double(ministerios[i,1])
  numeros_ok <- numeros_ok %>% mutate(id_ministerio = if_else(id_linea >= lim_inferior,  q_ministerio, id_ministerio ))
}

#- arreglo ministerios para q no se meta demasiado info en numeros_ok
ministerios <- ministerios %>% rename(Ministerio = linea) 
ministerios <- ministerios %>% select(id_ministerio, Ministerio)
ministerios <- ministerios %>% mutate(id_ministerio = as.numeric(id_ministerio))

#- incorporo nombre de Ministerio
numeros_ok <- left_join(numeros_ok, ministerios, by = c("id_ministerio"))
ministerios_ok <- ministerios

#-
rm(i, lim_inferior, lim_superior, q_ministerio, ministerios)


#- ahora he de añadir el resto de organismos, para ello has de quitarlos ministerios de aa (creo aa_resto)
aa_resto <- aa %>% filter(!(str_detect(linea, "^MINISTE"))) #- quita las 12 lineas de ministerios (DIFIERE 2017-2018)
aa_resto <- aa_resto %>% filter(!(str_detect(linea, "NºIOE"))) #- 685 vs.  668 (DIFIERE 2017-2018)
aa_resto <- aa_resto %>% filter(!(str_detect(linea, "Formada por:"))) #- 661 vs. 644
aa_resto <- aa_resto %>% filter(!(str_detect(linea, "^[[:digit:]]"))) #- 179 vs 170

#- ok quedan 170 lineas con organismos
aa_resto <- aa_resto %>% mutate(incre_linea = id_linea-lead(id_linea))
aa_resto$incre_linea[nrow(aa_resto)] <- -55
ultimo_org <- aa_resto %>% filter(incre_linea < -1)  #- 99 ultimos organismos
ultimo_org <- ultimo_org %>% mutate(id_no = 1:n()) %>% select(id_no, everything())

#- añadir el ultimo organismo para cada operacion estadistica
numeros_ok <- numeros_ok %>% mutate(ult_organismo = NA) #- creo una nueva columna para meter el ult_org

for (i in 1:nrow(ultimo_org)){
  yy = as.numeric(ultimo_org$id_linea[i])
  numeros_ok$ult_organismo[which(numeros_ok$id_linea == yy+2)] <- ultimo_org$id_no[i]
  }
numeros_ok <- numeros_ok %>% rename(cod_ult_org = ult_organismo) 
ultimo_org <- ultimo_org %>% select(id_no, linea) %>% rename(cod_ult_org = id_no) %>% rename(ultimo_org = linea)

numeros_ok <- left_join(numeros_ok, ultimo_org, by= "cod_ult_org")
ultimo_org_ok <- ultimo_org

rm(ultimo_org)


#- añadir el PENULTIMO organismo 
#- para ello primero quitar lineas de aa
aa_resto <- aa %>% filter(!(str_detect(linea, "^MINITE"))) #- quita las 12 lineas de ministerios (DIFIERE 2017-2018)
aa_resto <- aa_resto %>% filter(!(str_detect(linea, "NºIOE"))) #- 668 (DIFIERE 2017-2018)
aa_resto <- aa_resto %>% filter(!(str_detect(linea, "Formada por:"))) #- 644
aa_resto <- aa_resto %>% filter(!(str_detect(linea, "^[[:digit:]]"))) #- 170

#- calculo incrementos de id para ver cuando saltamos de operacion
aa_resto <- aa_resto %>% mutate(incre_linea = id_linea-lead(id_linea))
aa_resto$incre_linea[nrow(aa_resto)] <- -55
penultimo_org <- aa_resto %>% filter(!(incre_linea < -1)) #- 71 quedan (xq se van los 99 )
penultimo_org <- penultimo_org %>% mutate(incre_linea = id_linea-lead(id_linea)) #- 71
penultimo_org$incre_linea[nrow(penultimo_org)] <- -55
penultimo_org <- penultimo_org %>% filter(incre_linea < -1)  # #- 54 PEnultimos organismos (OK)
penultimo_org <- penultimo_org %>% mutate(id_no = 1:n()) %>% select(id_no, everything())

#- añadir el PE-nultimo organismo para cada operacion estadistica
numeros_ok <- numeros_ok %>% mutate(cod_penult_org = NA) #- la inicializo

for (i in 1:nrow(penultimo_org)){
  yy = as.numeric(penultimo_org$id_linea[i])
  numeros_ok$cod_penult_org[which(numeros_ok$id_linea == yy+3)] <- penultimo_org$id_no[i]
}

penultimo_org <- penultimo_org %>% select(id_no, linea) %>% rename(cod_penult_org = id_no) %>% rename(penultimo_org = linea)

numeros_ok <- left_join(numeros_ok, penultimo_org, by= "cod_penult_org")
penultimo_org_ok <- penultimo_org

rm(penultimo_org, i , yy)


#- añadir el ANTE-PENULTIMO organismo 
#- para ello primero quitar lineas de aa
aa_resto <- aa %>% filter(!(str_detect(linea, "^MINISTE"))) #- quita las 12 lineas de ministerios (DIFIERE 2017-2018)
aa_resto <- aa_resto %>% filter(!(str_detect(linea, "NºIOE"))) #- 668 (DIFIERE 2017-2018)
aa_resto <- aa_resto %>% filter(!(str_detect(linea, "Formada por:"))) #- 644
aa_resto <- aa_resto %>% filter(!(str_detect(linea, "^[[:digit:]]"))) #- 170
aa_resto <- aa_resto %>% mutate(incre_linea = id_linea-lead(id_linea))
aa_resto$incre_linea[nrow(aa_resto)] <- -55
penultimo_org <- aa_resto %>% filter(!(incre_linea < -1)) #- 71 quedan (xq se van los 99 )
penultimo_org <- penultimo_org %>% mutate(incre_linea = id_linea-lead(id_linea)) #- 71
penultimo_org$incre_linea[nrow(penultimo_org)] <- -55
Antepenultimo_org <- penultimo_org %>% filter(!(incre_linea < -1))  # #- 17 antepenultimos (OK)
Antepenultimo_org <- Antepenultimo_org %>% mutate(id_no = 1:n()) %>% select(id_no, everything())

#- añadir el ANTE- PEnultimo organismo para cada operacion estadistica
numeros_ok <- numeros_ok %>% mutate(cod_antepenult_org = NA) #- la inicializo

for (i in 1:nrow(Antepenultimo_org)){
  yy = as.numeric(Antepenultimo_org$id_linea[i])
  numeros_ok$cod_antepenult_org[which(numeros_ok$id_linea == yy+4)] <- Antepenultimo_org$id_no[i]
}

Antepenultimo_org <- Antepenultimo_org %>% select(id_no, linea) %>% rename(cod_antepenult_org = id_no) %>% rename(antepenultimo_org = linea)

numeros_ok <- left_join(numeros_ok, Antepenultimo_org, by= "cod_antepenult_org")
antepenultimo_org_ok <- Antepenultimo_org

rm(Antepenultimo_org, i, yy)

#- aun arreglo mas numeros_ok (lleno los huecos de "code") en otra variable
numeros_ok <- numeros_ok %>% mutate(code_filled = code) %>% select(code_filled, everything())
numeros_ok <- numeros_ok %>% mutate(cod_ult_org_filled = cod_ult_org)
numeros_ok <- numeros_ok %>% mutate(ult_org_filled = ultimo_org)

for (i in 2:nrow(numeros_ok)){
  if (is.na(numeros_ok[[i,1]])) {
    numeros_ok[[i,1]] <- numeros_ok[[i-1,1]]
    numeros_ok[[i,14]] <- numeros_ok[[i-1,14]]  #- la 14ª columna : cod_ult_org_filled
    numeros_ok[[i,15]] <- numeros_ok[[i-1,15]]  #- la 14ª columna : ult_org_filled
  } 
}

rm(lista_x_organismos, aa_resto, aa, i, penultimo_org, penultimo_org_ok, ultimo_org_ok, antepenultimo_org_ok)


#- uniformar +- nombres de los df
df_estad_x_org_ok <- numeros_ok

rm(numeros_ok)

#- arreglar nombres y tipos de  df_estad_x_org_ok
df_estad_x_org_ok <- df_estad_x_org_ok %>% mutate(codigo_op_estadistica = as.numeric(code)) %>% select(-code)
df_estad_x_org_ok <- df_estad_x_org_ok %>% mutate(code_filled = as.numeric(code_filled)) 
df_estad_x_org_ok <- df_estad_x_org_ok %>% rename(cod_IOE = code_1)
df_estad_x_org_ok <- df_estad_x_org_ok %>% mutate(cod_IOE = ifelse(cod_IOE == "-------", NA, cod_IOE))
df_estad_x_org_ok <- df_estad_x_org_ok %>% mutate(cod_IOE = as.numeric(cod_IOE))
df_estad_x_org_ok <- df_estad_x_org_ok %>% rename(op_estadistica_2 = linea_n_1) %>% select(-id_linea)

df_estad_x_org_ok <- df_estad_x_org_ok %>% select(cod_IOE, code_filled, codigo_op_estadistica, everything())



#----------------------------------------  TERCERO parseamos  la lista de operaciones (está el ppto)

#- parsear el listado de operaciones estadisticas (operaciones una a una con su descripcion)
#- voy a por la lista_operaciones
aa <- lista_operaciones
aa <- aa %>% set_names("linea")
aa <- aa %>% map(str_trim, side = "both") %>% as.tibble() #- quita caracteres al final
aa <- aa %>% mutate(id_linea = 1:n())  #- 4487

bb <- aa %>% filter((str_detect(linea, "Organismos que")))  #-      400 xq hay 400 operaciones estadisticas     
cc <- aa %>% filter((str_detect(linea, "Trabajos que")))    #-      400       
dd <- aa %>% filter((str_detect(linea, "Créditos presupuestarios")))  #-     400        

#- AQUI es donde encontre el fallo q corrijo arriba arriba
#- ee <- aa %>% filter((str_detect(linea, "^[[:digit:]]")))  #-    799, falta 1 (NO, aun esta mas liado) xq hay 4 q no tienen creditos asignados        
#- ee <- ee %>% slice(-c(792,793,794)) #- 796 (OK) he de aprender mas regex
#- ff <- aa %>% filter((str_detect(linea, "euros previstos")))  #-    396 con euros (deberian ser 400)        
#- 799-396 = 403 (o sea, hay 3 raros) y 4 operaciones sin creditos asignados

ee_vect <- as.vector(dd$id_linea) #- cojo los index de las lineas  donde aparece "Créditos presupuestarios"
ee_vect <- ee_vect+1 #- el dinero asignado esta en la siguiente linea
ee <- aa[ee_vect,]

ff <- aa %>% filter((str_detect(linea, "^[0-9]{4}")))  #- 407 en 2018 vs. 400 operaciones 
ff <- ff %>% mutate(id_op = 1:n())  %>% select(id_op, everything())

#- junto operaciones (ff) con pptos asignado (ee)
oper_ppto <- bind_cols(ff, ee) %>% select(-id_linea1)

#- arreglar el dinerito
oper_ppto <- oper_ppto %>% mutate(ppto = linea1)
oper_ppto <- oper_ppto %>%  mutate(ppto = ifelse(str_detect(ppto, "No aplicable" ), NA, ppto))
oper_ppto <- oper_ppto %>%  mutate(ppto = str_replace_all(ppto, " miles de euros previstos en el Presupuesto del", ""))

#- hay 2 lineas (174 y 308) q tienen PPTop de 2 organismos (en 2018 son 3: 176, 282, 308)
oper_ppto <- oper_ppto %>%  separate(ppto, into = c("ppto1", "ppto2"), sep = "y")

#- hay un problema con el seprador de miles q no se detecta con "."
oper_ppto <- oper_ppto %>%  mutate(ppto1 = str_replace_all(ppto1, ",", "GAGON4"))
oper_ppto <- oper_ppto %>%  mutate(ppto2 = str_replace_all(ppto2, ",", "GAGON4"))
oper_ppto <- oper_ppto %>%  mutate(ppto1 = str_replace_all(ppto1, "[[:punct:]]", ""))
oper_ppto <- oper_ppto %>%  mutate(ppto2 = str_replace_all(ppto2, "[[:punct:]]", ""))
oper_ppto <- oper_ppto %>%  mutate(ppto1 = str_replace_all(ppto1, "GAGON4", "."))
oper_ppto <- oper_ppto %>%  mutate(ppto2 = str_replace_all(ppto2, "GAGON4", "."))

#- separar el importe del organismo q lo financia
oper_ppto <- oper_ppto %>%  separate(ppto1, into = c("ppto1", "org_ppto1"), sep = " ")
oper_ppto <- oper_ppto %>% map(str_trim, side = "both") %>% as.tibble() #- quita caracteres al final y ppio
oper_ppto <- oper_ppto %>%  separate(ppto2, into = c("ppto2", "org_ppto2"), sep = " ")

#- calcular ppto_total (hay 2 casos en q hay q sumar)
oper_ppto <- oper_ppto %>% mutate(ppto1 = as.numeric(ppto1)) %>% mutate(ppto2 = as.numeric(ppto2))
oper_ppto <- oper_ppto %>% mutate(ppto2 = if_else(is.na(ppto2), 0, ppto2))
oper_ppto <- oper_ppto %>% mutate(ppto_total = ppto1+ppto2)
oper_ppto <- oper_ppto %>% select(-linea1)


#- organismos q intervienen:
#zz <- bind_cols(bb, cc) %>% mutate(dif_id = id_linea-id_linea1)  #- si, solo hay una linea con los organismos

bb_vect <- as.vector(bb$id_linea) #- cojo los index de las lineas  donde aparece "Créditos presupuestarios"
bb_vect <- bb_vect+1 #- el dinero asignado esta en la siguiente linea
bb_o <- aa[bb_vect,]
oper_ppto <- bind_cols(oper_ppto, bb_o)  
oper_ppto <- oper_ppto %>% select(-id_linea1)
oper_ppto <- oper_ppto %>% mutate(org_involu = linea1)

oper_ppto <- oper_ppto %>% 
  separate(org_involu, into = c("org_involu1", "org_involu2", "org_involu3", "org_involu4", "org_involu5", "org_involu6", "org_involu7", "org_involu8", "org_involu9", "org_involu10", "org_involu11", "org_involu12"), sep = ",", extra = "merge") 

oper_ppto <- oper_ppto %>% select(-linea1)

oper_ppto <- oper_ppto %>% map(str_trim, side = "both") %>% as.tibble() #- quita caracteres al final y al ppio

oper_ppto <- oper_ppto %>% map(str_trim, side = "both") %>% as.tibble() #- quita caracteres al final

oper_ppto <- oper_ppto %>% select(-org_involu12)

oper_ppto <- oper_ppto %>% 
  separate(linea, into = c("codigo_op_estadistica", "op_estadistica"), sep = 5)

#- trabajos que se van a hacer en 2017
zz <- bind_cols(cc,ee)
zz <- zz %>% mutate(n1 = id_linea+1)
zz <- zz %>% mutate(n2 = id_linea1-2)
zz <- zz %>% select(-linea1) %>% mutate(n_tot = (n2-n1)+1)  #- el maximo son 20 lineas

#---- generar los vectores con los indices de las operaciones para asignar tema a las operaciones
oper_ppto <- oper_ppto %>% mutate(Trabajos_ejec = 777)
for (i in 1:nrow(zz)){
  lim_inferior  <- as.integer(zz[i,4])
  lim_superior  <- as.integer(zz[i,5])
  txt <- ""
  for (j in lim_inferior:lim_superior){
  txt   <- paste(txt, aa[j,1])
  }
  oper_ppto$Trabajos_ejec[i] <- txt
}

#- quitar variables innecesarias
df_ppto_ok <- oper_ppto %>% select(-c(id_op, op_estadistica, id_linea))

#- pptos a numerico
df_ppto_ok <- df_ppto_ok %>% mutate(ppto1 = as.numeric(ppto1))
df_ppto_ok <- df_ppto_ok %>% mutate(ppto2 = as.numeric(ppto2))
df_ppto_ok <- df_ppto_ok %>% mutate(ppto_total = as.numeric(ppto_total))

#- pasarlo a numerico (para poder fusionar)
df_ppto_ok <- df_ppto_ok %>% mutate(codigo_op_estadistica = as.numeric(codigo_op_estadistica))

# FUSIONANDO con listado por temas
df_A_ok <- left_join(df_estad_x_temas, df_ppto_ok, by = "codigo_op_estadistica")

#- A FUSIONAR df_A_ok (400 rows)   con df_estad_x_org_ok (474 rows)

df_400_op_ok <- left_join(df_A_ok, df_estad_x_org_ok, by = "codigo_op_estadistica") #- Ahora SI salen 400

df_474_op_ok <- left_join( df_estad_x_org_ok, df_A_ok, by = "codigo_op_estadistica")

#- quito objetos innecesarios
df_quedarse <- c("df_400_op_ok", "df_474_op_ok", "df_estad_x_org_ok", "df_estad_x_temas", "df_org_ok", "df_ppto_ok", "ministerios_ok")
rm(list= ls()[!(ls() %in% df_quedarse)])   #- remueve todo excepto

#------------------ JUGAR a ver q sale
jugar <- df_400_op_ok %>% select(codigo_op_estadistica, op_estadistica, ppto_total, ppto1, org_ppto1, Ministerio, sector , Trabajos_ejec)

jugar2 <- jugar %>% arrange(desc(ppto_total))


#- Ver si cuadra con los resultados del PDF

#- SOLO queda fusionar 2017 y 2018
