library(readxl)
#dir.create("./data")
cod_provincias <- read_excel("./data-raw/cod_provincias.xlsx")
devtools::use_data(cod_provincias)
#save(cod_provincias, file="./data/cod_provincias.RData") #- guardamos my_data en formato .RData o .rda

#- acuerdate de documentar cada nuevo fichero de datos q añadas en el fichero:
#- ./R./data.R

devtools::document()
#devtools::use_vignette("my_vignette")


#----- Instalarlo dsde Local
install.packages("C:/Users/perezp/Desktop/a_GIT_2016a/mypkgfordata", repos = NULL, type="source")
library(mypkgfordata)
aa <- data("cod_provincias")
#--- instalarlo desde Github
devtools::install_github("perezp44/mypkgfordata")



#- Github

cd c:/Users/perezp/Desktop/a_GIT_2016a/mypkgfordata
git remote add origin https://github.com/perezp44/mypkgfordata.git


git add .
git commit --all --message "Creando el REPO"



aa <- data("cod_provincias")
