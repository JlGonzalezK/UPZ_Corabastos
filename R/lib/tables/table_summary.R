# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.
# CC BY-NC-SA 4.0.

tabla_categorica_resumen <- function(data,
                                     variable_categorica,
                                     variable_agrupadora = NULL,
                                     edad_var            = P_EDADR,
                                     usar_etiquetas      = TRUE,
                                     modo_porcentaje     = FALSE,
                                     digitos             = 1,
                                     excluir_valores     = c(9, 99),
                                     valores_fill        = 0) {
  
  var_cat_enquo <- rlang::enquo(variable_categorica)
  edad_enquo    <- rlang::enquo(edad_var)
  
  stopifnot(rlang::as_name(var_cat_enquo) %in% names(data))
  if (!is.null(variable_agrupadora)) {
    agrupadora_enquo <- rlang::enquo(variable_agrupadora)
    stopifnot(rlang::as_name(agrupadora_enquo) %in% names(data))
  }
  
  data <- data %>%
    dplyr::filter(!is.na(!!var_cat_enquo), 
                  !(!!var_cat_enquo %in% excluir_valores)) %>%
    dplyr::mutate(
      categoria = if (usar_etiquetas) haven::as_factor(!!var_cat_enquo) 
      else !!var_cat_enquo
    )
  
  if (is.null(variable_agrupadora)) {
    data <- data %>%
      dplyr::filter(!is.na(!!edad_enquo)) %>%
      dplyr::mutate(
        agrupadora = dplyr::case_when(
          !!edad_enquo == 1      ~ "Primera infancia",
          !!edad_enquo %in% 2:3  ~ "Infancia",
          !!edad_enquo == 4      ~ "Adolescencia",
          !!edad_enquo %in% 5:6  ~ "Juventud",
          !!edad_enquo %in% 7:12 ~ "Adultez",
          !!edad_enquo >= 13     ~ "Vejez"
        )
      )
  } else {
    agrupadora_enquo <- rlang::enquo(variable_agrupadora)
    data <- data %>%
      dplyr::filter(!is.na(!!agrupadora_enquo), 
                    !(!!agrupadora_enquo %in% excluir_valores)) %>%
      dplyr::mutate(
        agrupadora = if (usar_etiquetas) haven::as_factor(!!agrupadora_enquo) 
        else !!agrupadora_enquo
      )
  }
  
  total_global <- nrow(data)
  
  tabla <- data %>%
    dplyr::count(categoria, agrupadora) %>%
    tidyr::pivot_wider(
      names_from  = agrupadora,
      values_from = n,
      values_fill = valores_fill
    )
  
  if (modo_porcentaje) {
    tabla <- tabla %>%
      dplyr::mutate(
        dplyr::across(where(is.numeric), ~ round(.x / total_global * 100, 
                                                 digitos))
      )
  }
  
  tabla <- tabla %>%
    dplyr::mutate(Total = round(rowSums(dplyr::across(where(is.numeric))), 
                                digitos)) %>%
    dplyr::arrange(desc(Total))
  
  return(tabla)
}
