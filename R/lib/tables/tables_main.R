# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.
# CC BY-NC-SA 4.0.

# tabla distribución genérica (facetas) 
tabla_distribucion_faceta <- function(data, x_var, fill_var, facet_var) {
  x_enquo     <- rlang::enquo(x_var)
  fill_enquo  <- rlang::enquo(fill_var)
  facet_enquo <- rlang::enquo(facet_var)
  
  data %>%
    dplyr::filter(!is.na(!!x_enquo), !is.na(!!fill_enquo), 
                  !is.na(!!facet_enquo)) %>%
    dplyr::mutate(
      x     = haven::as_factor(!!x_enquo),
      fill  = haven::as_factor(!!fill_enquo),
      facet = haven::as_factor(!!facet_enquo)
    ) %>%
    dplyr::count(x, facet, fill) %>%
    dplyr::group_by(x, facet) %>%
    dplyr::mutate(pct = round(n / sum(n), 3)) %>%
    dplyr::ungroup()
}

# promedios por edad
tabla_promedio_por_edad <- function(data,
                                    variable_numerica,
                                    variable_edad     = P_EDADR,
                                    sexo_filtrado     = NULL,
                                    valores_na        = c(99),
                                    rango_edad        = NULL,
                                    agrupar_por_etapa = FALSE,
                                    usar_etiquetas    = TRUE,
                                    digitos           = 2) {
  var_num_enquo  <- rlang::enquo(variable_numerica)
  edad_enquo     <- rlang::enquo(variable_edad)
  
  data <- data %>%
    dplyr::mutate(!!rlang::as_name(var_num_enquo) := na_if(!!var_num_enquo, 
                                                           valores_na)) %>%
    dplyr::filter(!is.na(!!var_num_enquo), !is.na(!!edad_enquo))
  
  if (!is.null(sexo_filtrado)) {
    data <- dplyr::filter(data, P_SEXO == sexo_filtrado)
  }
  
  if (!is.null(rango_edad)) {
    data <- dplyr::filter(data, !!edad_enquo %in% rango_edad)
  }
  
  data <- data %>%
    dplyr::mutate(grupo_edad = dplyr::case_when(
      agrupar_por_etapa ~ dplyr::case_when(
        !!edad_enquo == 1        ~ "Primera infancia",
        !!edad_enquo %in% 2:3    ~ "Infancia",
        !!edad_enquo == 4        ~ "Adolescencia",
        !!edad_enquo %in% 5:6    ~ "Juventud",
        !!edad_enquo %in% 7:12   ~ "Adultez",
        !!edad_enquo >= 13       ~ "Vejez"
      ),
      usar_etiquetas    ~ as.character(haven::as_factor(!!edad_enquo)),
      TRUE              ~ as.character(!!edad_enquo)
    ))
  
  total_casos <- nrow(data)
  
  data %>%
    dplyr::group_by(grupo_edad) %>%
    dplyr::summarise(
      casos     = dplyr::n(),
      total     = sum(!!var_num_enquo),
      promedio  = round(total / casos, digitos),
      porcentaje = round(casos / total_casos * 100, 1),
      .groups   = "drop"
    ) %>%
    dplyr::arrange(grupo_edad)
}

tabla_resumen_grupo <- function(data,
                                var_num,     
                                var_grupo,     
                                valores_na     = c(99),
                                usar_etiquetas = TRUE,
                                digitos        = 2) {
  var_num_enquo   <- rlang::enquo(var_num)
  var_grupo_enquo <- rlang::enquo(var_grupo)
  var_num_name    <- rlang::as_name(var_num_enquo)
  
  moda_func <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
  }
  
  data <- data %>%
    dplyr::mutate(
      !!var_num_name := na_if(!!var_num_enquo, valores_na),
      grupo = if (usar_etiquetas) haven::as_factor(!!var_grupo_enquo) else !!var_grupo_enquo
    ) %>%
    dplyr::filter(!is.na(grupo), !is.na(!!var_num_enquo))
  
  total_casos <- nrow(data)
  
  data %>%
    dplyr::group_by(grupo) %>%
    dplyr::summarise(
      casos      = dplyr::n(),
      media      = round(mean(!!var_num_enquo), digitos),
      mediana    = round(median(!!var_num_enquo), digitos),
      moda       = moda_func(!!var_num_enquo),
      porcentaje = round(casos / total_casos * 100, 1),
      .groups    = "drop"
    ) %>%
    dplyr::arrange(grupo)
}

# tabla cruzada pra variables categoricas
tabla_cruzada_categorica <- function(data,
                                     var1,
                                     var2,
                                     usar_etiquetas = TRUE,
                                     tipo = "fila",
                                     digitos = 1) {
  v1 <- rlang::enquo(var1)
  v2 <- rlang::enquo(var2)
  
  df <- data %>%
    dplyr::filter(!is.na(!!v1), !is.na(!!v2)) %>%
    dplyr::mutate(
      v1_lab = if (usar_etiquetas) haven::as_factor(!!v1) else !!v1,
      v2_lab = if (usar_etiquetas) haven::as_factor(!!v2) else !!v2
    ) %>%
    dplyr::count(v1_lab, v2_lab)
  
  df <- dplyr::case_when(
    tipo == "fila" ~ df %>% dplyr::group_by(v1_lab) %>%
      dplyr::mutate(pct = round(n / sum(n) * 100, digitos)),
    
    tipo == "columna" ~ df %>% dplyr::group_by(v2_lab) %>%
      dplyr::mutate(pct = round(n / sum(n) * 100, digitos)),
    
    TRUE ~ df %>% dplyr::mutate(pct = round(n / sum(n) * 100, digitos))
  )
  
  df %>% dplyr::ungroup()
}
