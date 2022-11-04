#read IDEAM climate data, filtering, mapping and interpolate
library(raster)
library(tidyverse)
library(sp)
library(terra)
require(rgdal)
library(readr)

setwd("F:/Raw_data/IDEAM")

datos_1<-list.files("./FOLDER_NAME", pattern = ".data",full.names = TRUE, all.files = FALSE)

data <- purrr::map(datos_1,
                 function(file){
                   df <- read_delim(file,delim = "|",col_names = TRUE,col_types=NULL,id="path")
                  col_names = c("Fecha","Valor")
                   current_names <- names(df)
                   return(df)
                 }
)

output <- bind_rows(data)
base<-output %>% mutate(variable=str_extract(path,pattern = "(?<=FOLDER_NAME/).*(?=@)"),  
                        code=str_extract(path, pattern="(?<=@).*(?=.data)"),
                        fecha=as.Date(Fecha)) %>%   
                        select(fecha,code,variable,Valor)
