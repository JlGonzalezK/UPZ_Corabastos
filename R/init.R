# Script principal
# CC BY-NC-SA 4.0.
# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.

if(!require("pacman")) install.packages("pacman"); library(pacman)
p_load(arrow, digest, dplyr, fs, ggplot2, haven, labelled, purrr, readr, readxl,
       rlang, sf, stringr, scales, tibble,tidyr)

source("R/lib/tables/tables_main.R")
source("R/lib/tables/tables_dem.R")
source("R/lib/tables/table_summary.R")
source("R/lib/plot/plotbar_basic.R")
source("R/lib/plot/plotbar_faceted.R")
source("R/lib/plot/plot_ojives.R")
source("R/lib/plot/plot_pyramid.R")

upz80 <- read_rds("input/upz80_filtered.rds")

list2env(upz80$cnpv, envir = .GlobalEnv)

################################### GENERAL ####################################

# Pirámide poblacional de la UPZ
piramide_pob(cnpv_5per_filter, age = P_EDADR, gender = P_SEXO,
             title = "Distribución Demográfica por Edad y Sexo - UPZ 80")

# Tabla poblacional detallada de la UPZ
tabla_poblacion_sexo(cnpv_5per_filter)

# Estado civil

grafico_barras_simple(cnpv_5per_filter, 
                      P_EST_CIVIL, 
                      titulo    = "Estado civil - subpoblación UPZ 80",
                      x_label = " estado civil",
                      y_label   = "ultimo grado alcanzado",
                      fill_label = "Ulitmo grado alcanzado")

tabla_categorica_resumen(
  data                = cnpv_5per_filter,
  variable_categorica = P_EST_CIVIL,
  modo_porcentaje     = TRUE
)

################################## FECUNDIDAD ##################################

tabla_fecundidad_upz80 <- tabla_fecundidad(cnpv_5per_filter,filtrar_rango = TRUE)

# Distribución de mujeres en edad fértil (15–49 años)
grafico_valores_agrupados(
  data       = tabla_fecundidad_upz80,
  x_var      = grupo_edad,
  y_var      = porcentaje,
  fill_var   = grupo_edad,
  titulo     = "Distribución de mujeres en edad fértil (15–49 años)",
  x_label    = "Edad reproductiva (grupo)",
  y_label    = "Porcentaje",
  fill_label = "Grupo de edad"
)

# Tasa de fecundidad por edad de mujeres en edad reproductiva
grafico_porcentual(
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
grafico_curva_valores(
  data       = tabla_fecundidad(cnpv_5per_filter,filtrar_rango = FALSE),
  x_var      = grupo_edad,
  y_var      = fecundidad_media,
  titulo     = "Curva de fecundidad media según grupo etario (CNPV 2018)",
  x_label    = "Grupo de edad",
  y_label    = "Hijos nacidos vivos por mujer"
)

################################# ESCOLARIDAD ##################################

tabla_categorica_resumen(
  data                = cnpv_5per_filter,
  variable_categorica = P_NIVEL_ANOSR,
  modo_porcentaje = TRUE
)

# grados de escolaridad general
grafico_barras_simple(cnpv_5per_filter, 
                      P_NIVEL_ANOSR, 
                      titulo    = "Grados de escolaridad - UPZ 80",
                      y_label   = "ultimo grado alcanzado",
                      fill_label = "Ulitmo grado alcanzado")

tabla_resumen_grupo(cnpv_5per_filter, P_NIVEL_ANOSR, P_NIVEL_ANOSR)

# Gráfico de escolaridad por edad (porcentaje relativo)
grafico_proporciones_cruzadas(
  data       = cnpv_5per_filter,
  x_var      = P_EDADR,
  fill_var   = P_NIVEL_ANOSR,
  titulo     = "Escolaridad por edad (porcentaje relativo)",
  x_label    = "Rango etario",
  fill_label = "Nivel de escolaridad"
)

tabla_resumen_grupo(cnpv_5per_filter, P_NIVEL_ANOSR, P_EDADR)

# asistencia a centro educativo por grupos de edad
grafico_proporciones_cruzadas(
  data       = cnpv_5per_filter,
  x_var      = P_EDADR,
  fill_var   = PA_ASISTENCIA,
  titulo     = "Asistencia educativa por etapa de vida (porcentaje relativo)",
  x_label    = "Etapa de vida",
  fill_label = "Asistencia escolar"
)
tabla_resumen_grupo(cnpv_5per_filter, PA_ASISTENCIA, P_EDADR)

# Gráfico Distribución educativa por edad y sexo
tabla_f_edu <- tabla_distribucion_faceta(cnpv_5per_filter, 
                                           P_EDADR, 
                                           P_NIVEL_ANOSR, 
                                           P_SEXO)
# Distribución educativa por edad y sexo
grafico_faceta(tabla_f_edu,
               titulo = "Distribución educativa por edad y sexo (porcentaje relativo)",
               x_label = "Grupo etario",
               y_label = "Proporción (%)",
               fill_label = "Nivel educativo",
               facet_label = "Sexo")

# Gráfico de escolaridad por sexo (proporción relativa) -OJO ajustar colores
grafico_proporciones_cruzadas(
  data       = cnpv_5per_filter,
  x_var      = P_NIVEL_ANOSR,
  fill_var   = P_SEXO,
  titulo     = "Escolaridad por sexo (proporción relativa)",
  x_label    = "Nivel educativo",
  fill_label = "Sexo"
)

# Gráfico comparativo escolaridad por edad y sexo (líneas superpuestas)"
grafico_ojiva_faceta(
  cnpv_5per_filter,
  P_EDADR,
  P_SEXO,
  P_NIVEL_ANOSR,
  "Comparación de escolaridad por edad y sexo (líneas superpuestas)"
)

################################## OCUPACION ###################################

# actividad laboral por edad (grupos quinquenales)
grafico_ciclo_vida(
  cnpv_5per_filter, 
  variable = P_TRABAJO, 
  titulo = "Actividad laboral por grupo etario (ultima semana)")

tabla_por_etapa_filtrada(cnpv_5per_filter, P_TRABAJO, etapa_seleccionada = "Vejez")

# Actividad laboral por nivel educativo
grafico_proporciones_cruzadas(
  data      = cnpv_5per_filter,
  x_var     = P_NIVEL_ANOSR,
  fill_var  = P_TRABAJO,
  x_label   = "Nivel educativo alcanzado",
  fill_label = "Actividad reciente",
  titulo    = "Actividad laboral según nivel educativo"
)

#################### MIGRACION 

# Gráfico Lugar de nacimiento por grupo etario - UPZ 80
grafico_proporciones_cruzadas(
  data       = cnpv_5per_filter,
  x_var      = P_EDADR,
  fill_var   = PA_LUG_NAC,
  titulo     = "Lugar de nacimiento por grupo etario - UPZ 80",
  x_label    = "Grupo etario",
  fill_label = "Lugar de nacimiento"
)

# Gráfico Lugar de nacimiento por grupo etario - UPZ 80
grafico_proporciones_cruzadas(
  data       = cnpv_5per_filter,
  x_var      = PA_LUG_NAC,
  fill_var   = P_TRABAJO,
  titulo     = "Situación laboral por lugar de nacimiento- UPZ 80",
  x_label    = "Grupo etario",
  fill_label = "Lugar de nacimiento"
)

# Gráfico Lugar de nacimiento por grupo etario - UPZ 80
grafico_proporciones_cruzadas(
  data = cnpv_5per_filter %>%
    dplyr::filter(PA_LUG_NAC != 9, P_NIVEL_ANOSR != 9),
  x_var      = PA_LUG_NAC,
  fill_var   = P_NIVEL_ANOSR,
  titulo     = "Escolaridad por lugar de origen - UPZ 80",
  x_label    = "Grupo etario",
  fill_label = "Lugar de nacimiento"
)

# Gráfico Residencia hace 12 meses por grupo etario
grafico_proporciones_cruzadas(
  data       = cnpv_5per_filter %>% filter(PA_VIVIA_1ANO %in% 1:4, !is.na(P_EDADR)),
  x_var      = P_EDADR,
  fill_var   = PA_VIVIA_1ANO,
  titulo     = "Residencia hace 12 meses por grupo etario",
  x_label    = "Grupo etario",
  fill_label = "Residencia hace 1 año"
)

cnpv_5per_filter %>%
  dplyr::filter(!is.na(PA_VIVIA_1ANO)) %>%
  dplyr::mutate(residencia = haven::as_factor(PA_VIVIA_1ANO)) %>%
  dplyr::count(residencia) %>%
  dplyr::mutate(pct = round(n / sum(n) * 100, 1)) %>%
  dplyr::arrange(desc(n))

# Gráfico Residencia hace 5 años por grupo etario
cnpv_5per_filter %>%
  dplyr::filter(!is.na(PA_VIVIA_5ANOS)) %>%
  dplyr::mutate(residencia = haven::as_factor(PA_VIVIA_1ANO)) %>%
  dplyr::count(residencia) %>%
  dplyr::mutate(pct = round(n / sum(n) * 100, 1)) %>%
  dplyr::arrange(desc(n))

grafico_proporciones_cruzadas(
  data       = cnpv_5per_filter,
  x_var      = P_EDADR,
  fill_var   = PA_VIVIA_5ANOS,
  titulo     = "Residencia hace 5 años por grupo etario",
  x_label    = "Grupo etario",
  fill_label = "Residencia hace 5 años"
)