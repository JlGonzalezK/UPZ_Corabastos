# Script principal
# CC BY-NC-SA 4.0.
# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.

if(!require("pacman")) install.packages("pacman"); library(pacman)
p_load(arrow, digest, dplyr, fs, ggplot2, haven, labelled, purrr, readr, readxl,
       rlang, sf, stringr, scales, tibble,tidyr)

source("R/utils/tables_lib.R")
source("R/utils/plot_main.R")
source("R/utils/plot_pyramid.R")

upz80 <- read_rds("input/upz80_filtered.rds")

list2env(upz80$cnpv, envir = .GlobalEnv)


################################### GENERAL ####################################

# Pirámide poblacional de la UPZ
piramide_pob(cnpv_5per_filter, age = P_EDADR, gender = P_SEXO,
             title = "Distribución Demográfica por Edad y Sexo - UPZ 80")

# Tabla poblacional detallada de la UPZ
tabla_poblacion <- tabla_poblacion_sexo(cnpv_5per_filter)

################################## FECUNDIDAD ##################################
# Tasa de fecundidad por edad de mujeres en edad reproductiva
grafico_valores_agrupados(
  data       = tabla_fecundidad(cnpv_5per_filter),
  x_var      = grupo_edad,
  y_var      = fecundidad_media,
  fill_var   = grupo_edad,
  titulo     = "Fecundidad media por grupo de edad",
  x_label    = "Grupo de edad quinquenal",
  y_label    = "Hijos nacidos vivos por mujer",
  fill_label = "Edad reproductiva"
)

# Curva de fecundidad media según grupo etario
grafico_curva_valores_agrupados(
  data       = tabla_fecundidad(cnpv_5per_filter,filtrar_rango = FALSE),
  x_var      = grupo_edad,
  y_var      = fecundidad_media,
  titulo     = "Curva de fecundidad media según grupo etario (CNPV 2018)",
  x_label    = "Grupo de edad",
  y_label    = "Hijos nacidos vivos por mujer"
)

################################# ESCOLARIDAD ##################################

# Escolaridad
grafico_por_etapa_sociologica(
  data = cnpv_5per_filter,
  variable = PA_ASISTENCIA,
  titulo = "Asistencia escolar por etapa sociológica",
  fill_label = "Asistencia"
)

################################## OCUPACION ###################################

# actividad laboral por grupos de edad
grafico_por_etapa_sociologica(
  cnpv_5per_filter, 
  variable = P_TRABAJO, 
  titulo = "Ocupación según etapa vital")

# actividad laboral por edad (grupos quinquenales)
grafico_por_edad_etiquetada(
  cnpv_5per_filter, 
  variable = P_TRABAJO, 
  titulo = "Actividad laboral por grupo etario (ultima semana)")

# Actividad laboral por nivel educativo
grafico_proporciones_cruzadas(
  data      = cnpv_5per_filter,
  x_var     = P_NIVEL_ANOSR,
  fill_var  = P_TRABAJO,
  x_label   = "Nivel educativo alcanzado",
  fill_label = "Actividad reciente",
  titulo    = "Actividad laboral según nivel educativo"
)
