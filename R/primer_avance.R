# -----------------------------------------------#
#    Script: Primer avance de investigación      #
# -----------------------------------------------#
# Asignatura: R para CCSS - UNAL                 #
# Autor     : Jorge Luis Gonzalez Castellanos    #
# email     : jlgonzalezca@unal.edu.co           #
# versión   : 1.03                               #
# Fecha     : [2025/06/23]                       #
# -----------------------------------------------#

# **INSTRUCCIONES:** para ejecutar el script correctamente y sin modificaciones,
# se recomienda clonar el repositorio del proyecto en su escritorio y descargar 
# el dataset allí, siguiendo la estructura sugerida, desde la página del DANE,
# en caso contrario, puede modificar la ruta a su conveniencia.
# (ver línea 23 de este script).

# instalar y/o cargar pacman para manejo eficiente de librerías
if(!require("pacman")) install.packages("pacman");library(pacman)

# cargar librerías requeridas
p_load(fs,here)

# cargar espacio de trabajo
path_wd <- path(path_home("Desktop"), "UPZ_Corabastos")
setwd(path_wd)

# crear objetos con las rutas de los datasets
path_CNPV2018_PER <- "sources/DANE/CNPV2018_11/CSV/CNPV2018_5PER_A2_11.CSV"

# importar dataset
CNPV_BOG <- read.csv(path_CNPV2018_PER)

# conteo de valores únicos para cada variable (usando base::sapply)
valores_unicos <- data.frame(
  variable = names(CNPV_BOG),
  valores_unicos = sapply(CNPV_BOG, n_distinct)
)

# conteo de valores faltantes (usando base::colSums)
valores_faltantes <- data.frame(
  variable = names(CNPV_BOG),
  valores_faltantes = colSums(is.na(CNPV_BOG))
)
