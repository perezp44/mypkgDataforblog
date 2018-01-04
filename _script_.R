#- PARA AÑADIR un nuevo df u objeto:
#- 1) Cargas el objeto en memoria de R con el archivo ./data-raw/make-datasets.R
#- 2) Para q vaya a memoria del pkg has de: devtools::use_data(CNIG_CCAA_sf, overwrite = TRUE) #
#- 3) Añadir la documentacion co roxygen en ./R/data.R
#- 4) Finalmente has de actualizar con: devtools::document()
#- 5) Llevarlo a Github

library(readxl)
#dir.create("./data")


# cod_provincias <- read_excel("./data-raw/cod_provincias.xlsx")
# devtools::use_data(cod_provincias)
# save(cod_provincias, file="./data/cod_provincias.RData") #- guardamos my_data en formato .RData o .rda


#- AQUI
#- acuerdate de documentar cada nuevo fichero de datos q añadas en el fichero:
#- ./R./data.R


#- Para q se modifique el NAMESPACE
devtools::document()


#- VIÑETAS
#devtools::use_vignette("my_vignette")


#----- Instalarlo dsde Local
# install.packages("C:/Users/perezp/Desktop/a_GIT_2016a/mypkgDataforblog", repos = NULL, type="source")
# library(mypkgfordata)
# aa <- data("cod_provincias")

#--- instalarlo desde Github
#devtools::install_github("perezp44/mypkgDataforblog")

#- para ver los datos q tengo

library(tidyverse)
devtools::install_github("perezp44/mypkgDataforblog")
library(mypkgDataforblog)

data(cod_provincias)

ls("package:mypkgDataforblog", all = TRUE) #- ves lo que hay en mypkgDataforblog
aa <- ls("package:mypkgDataforblog", all = TRUE) %>% as.data.frame()#- ves lo que hay en mypkgDataforblog

??mypkgDataforblog

vignette(package = "mypkgDataforblog")

bb <- padron_15_x_nac_res


#- Github

cd c:/Users/perezp/Desktop/a_GIT_2016a/mypkgDataforblog

git add -A    # stages all files
git add .
git commit --all --message "Creando el REPO"
git remote add origin https://github.com/perezp44/mypkgfordata.git

git push -u origin master



git add -A         # stages all files
git add .          # stages new and modified, without deleted
git add -u         # stages modified and deleted, without new
git add file.R     # stages just the 'file.R' file


