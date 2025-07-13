# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.
# CC BY-NC-SA 4.0.

# Tabla de población detallada
tabla_poblacion_sexo <- function(data, var_edad = P_EDADR, var_sexo = P_SEXO) {
  data %>%
    count(Edad = haven::as_factor({{ var_edad }}), sexo = {{ var_sexo }}) %>%
    pivot_wider(names_from = sexo, values_from = n, values_fill = 0) %>%
    transmute(
      Edad,
      Hombres = `1`,
      Mujeres = `2`,
      Total = Hombres + Mujeres,
      Porcentaje = round((Total / sum(Total)) * 100, 2),
      Masculinidad = if_else(Mujeres > 0, round(Hombres / Mujeres * 100, 1), 
                             NA_real_),
      Feminidad = if_else(Hombres > 0, round(Mujeres / Hombres * 100, 1), 
                          NA_real_)
    ) %>%
    arrange(Edad)
}

# Tabla de fecundidad
tabla_fecundidad <- function(
    data,
    variable_hijos   = PA1_THNV,
    agrupador_edad   = P_EDADR,
    rango_fertil     = 4:9,
    filtrar_rango    = TRUE
) {
  variable_hijos_enquo <- rlang::enquo(variable_hijos)
  agrupador_enquo      <- rlang::enquo(agrupador_edad)
  
  data <- data %>%
    filter(P_SEXO == 2, !is.na(!!agrupador_enquo)) %>%
    mutate(!!rlang::as_name(variable_hijos_enquo) := na_if(!!variable_hijos_enquo, 
                                                           99)) %>%
    filter(!is.na(!!variable_hijos_enquo))
  
  if (filtrar_rango) {
    data <- data %>% filter(P_EDADR %in% rango_fertil)
  }
  
  data %>%
    mutate(grupo_edad = haven::as_factor(!!agrupador_enquo)) %>%
    group_by(grupo_edad) %>%
    summarize(
      mujeres = n(),
      hijos_totales = sum(!!variable_hijos_enquo),
      fecundidad_media = round(hijos_totales / mujeres, 2),
      .groups = "drop"
    ) %>%
    mutate(
      porcentaje = round(mujeres / sum(mujeres) * 100, 1)
    ) %>%
    arrange(grupo_edad)
}

# tabla por etapas vitales
tabla_por_etapa_filtrada <- function(data,
                                     variable,
                                     etapa_seleccionada,
                                     edad_var         = P_EDADR,
                                     usar_etiquetas   = TRUE,
                                     digitos          = 1) {
  var_enquo  <- rlang::enquo(variable)
  edad_enquo <- rlang::enquo(edad_var)
  
  data <- data %>%
    dplyr::filter(!is.na(!!edad_enquo), !is.na(!!var_enquo)) %>%
    dplyr::mutate(
      etapa_vida = dplyr::case_when(
        !!edad_enquo == 1        ~ "Primera infancia",
        !!edad_enquo %in% 2:3    ~ "Infancia",
        !!edad_enquo == 4        ~ "Adolescencia",
        !!edad_enquo %in% 5:6    ~ "Juventud",
        !!edad_enquo %in% 7:12   ~ "Adultez",
        !!edad_enquo >= 13       ~ "Vejez"
      ),
      categoria = if (usar_etiquetas) haven::as_factor(!!var_enquo) else !!var_enquo
    ) %>%
    dplyr::filter(etapa_vida == etapa_seleccionada) %>%
    dplyr::count(categoria) %>%
    dplyr::mutate(
      pct = round(n / sum(n) * 100, digitos)
    ) %>%
    dplyr::arrange(desc(n))
  
  return(data)
}

# tabla cruzada por etapas
tabla_cruzada_por_etapa <- function(data,
                                    categoria_var,
                                    columna_var,
                                    usar_etiquetas   = TRUE,
                                    digitos          = 1,
                                    valores_fill     = 0,
                                    excluir_valores  = c(9, 98, 99),
                                    edad_var         = P_EDADR,
                                    agrupar_por_etapa = TRUE) {
  
  cat_enquo  <- rlang::enquo(categoria_var)
  col_enquo  <- rlang::enquo(columna_var)
  edad_enquo <- rlang::enquo(edad_var)
  
  data <- data %>%
    dplyr::filter(
      !is.na(!!edad_enquo), !is.na(!!cat_enquo), !is.na(!!col_enquo),
      !(!!cat_enquo %in% excluir_valores),
      !(!!col_enquo %in% excluir_valores)
    ) %>%
    dplyr::mutate(
      fila = if (agrupar_por_etapa) dplyr::case_when(
        !!edad_enquo == 1      ~ "Primera infancia",
        !!edad_enquo %in% 2:3  ~ "Infancia",
        !!edad_enquo == 4      ~ "Adolescencia",
        !!edad_enquo %in% 5:6  ~ "Juventud",
        !!edad_enquo %in% 7:12 ~ "Adultez",
        !!edad_enquo >= 13     ~ "Vejez"
      ) else if (usar_etiquetas) haven::as_factor(!!edad_enquo) else !!edad_enquo,
      categoria = if (usar_etiquetas) haven::as_factor(!!cat_enquo) else !!cat_enquo,
      columna   = if (usar_etiquetas) haven::as_factor(!!col_enquo) else !!col_enquo
    )
  
  data %>%
    dplyr::count(fila, columna) %>%
    dplyr::group_by(fila) %>%
    dplyr::mutate(pct = round(n / sum(n) * 100, digitos)) %>%
    dplyr::select(fila, columna, pct) %>%
    tidyr::pivot_wider(
      names_from  = columna,
      values_from = pct,
      values_fill = valores_fill
    ) %>%
    dplyr::arrange(fila)
}