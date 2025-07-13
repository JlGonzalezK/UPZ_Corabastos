# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.
# CC BY-NC-SA 4.0.

# gráfico de barras simpĺe
grafico_barras_simple <- function(
    data,
    variable,
    titulo     = "Distribución proporcional univariada",
    x_label    = NULL,
    y_label    = "Proporción (%)",
    fill_label = NULL
) {
  variable_enquo <- rlang::enquo(variable)
  var_name       <- rlang::as_name(variable_enquo)
  
  x_label    <- x_label    %||% var_name
  fill_label <- fill_label %||% labelled::var_label(data[[var_name]]) %||% var_name
  
  tabla <- data %>%
    dplyr::filter(!is.na(!!variable_enquo)) %>%
    dplyr::mutate(x = haven::as_factor(!!variable_enquo)) %>%
    dplyr::count(x) %>%
    dplyr::mutate(pct = round(n / sum(n), 3))
  
  ggplot2::ggplot(tabla, aes(x = x, y = pct, fill = x)) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::scale_y_continuous(labels = scales::percent_format()) +
    ggplot2::labs(
      title = titulo,
      x     = x_label,
      y     = y_label,
      fill  = fill_label
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_blank())
}

# gráfico por etapas de vida
grafico_ciclo_vida <- function( 
    data, 
    variable, 
    titulo = "Distribución por ciclo vital", 
    fill_label = "Categoría") { 
  data %>% 
    filter(!is.na(P_EDADR), !is.na({{ variable }})) %>% 
    mutate( 
      etapa_vida = case_when(
        P_EDADR == 1 ~ "Primera infancia",
        P_EDADR %in% 2:3 ~ "Infancia",
        P_EDADR == 4 ~ "Adolescencia",
        P_EDADR %in% 5:6 ~ "Juventud",
        P_EDADR %in% 7:12 ~ "Adultez",
        P_EDADR >= 13 ~ "Vejez"
      ), etapa_vida = factor(
        etapa_vida,
        levels = c(
          "Primera infancia",
          "Infancia",
          "Adolescencia",
          "Juventud",
          "Adultez",
          "Vejez"
        )
      ), categoria = haven::as_factor({{ variable }}) ) %>% 
    count(etapa_vida, categoria) %>% 
    group_by(etapa_vida) %>% 
    mutate(pct = round(n / sum(n) * 100, 1)) %>% 
    ggplot(aes(x = etapa_vida, 
               y = pct, 
               fill = categoria)) + 
    geom_bar(stat = "identity", position = "fill") + 
    scale_y_continuous(labels = scales::percent_format()) + 
    labs(x = "Grupo por etapa",
         y = "Proporción (%)", fill = fill_label, title = titulo) + 
    theme_minimal() + theme(
      axis.text.x = element_text(angle = 45,
                                 hjust = 1,
                                 size = 7))
}

# gráfico para porcentajes
grafico_porcentual <- function(data, 
                               x_var, 
                               y_var, 
                               fill_var = NULL, 
                               titulo = "Distribución proporcional", 
                               x_label = NULL, 
                               y_label = "Proporción (%)", 
                               fill_label = "Categoría", 
                               position = "identity") {
  x_enquo    <- rlang::enquo(x_var)
  y_enquo    <- rlang::enquo(y_var)
  fill_enquo <- rlang::enquo(fill_var)
  
  x_label    <- x_label     %||% rlang::as_label(x_enquo)
  fill_label <- fill_label  %||% rlang::as_label(fill_enquo)
  
  data %>%
    dplyr::filter(!is.na(!!x_enquo), !is.na(!!y_enquo)) %>%
    dplyr::mutate(x = haven::as_factor(!!x_enquo),
                  fill = haven::as_factor(!!fill_enquo)) %>%
    ggplot(aes(x = x, y = !!y_enquo, fill = fill)) +
    geom_bar(stat = "identity", position = position) +
    scale_y_continuous(labels = scales::percent_format(scale = 1)) +
    labs(title = titulo, x = x_label, y = y_label, fill = fill_label) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 7))
}

# Gráfico para valores agrupados
grafico_valores_agrupados <- function(
    data,
    x_var,
    y_var,
    fill_var = NULL,
    titulo = "Distribución de valores agregados",
    x_label = NULL,
    y_label = "Valor",
    fill_label = NULL
) {
  x_var_enquo    <- rlang::enquo(x_var)
  y_var_enquo    <- rlang::enquo(y_var)
  fill_var_enquo <- rlang::enquo(fill_var)
  
  ggplot(data, aes(x = !!x_var_enquo, 
                   y = !!y_var_enquo, 
                   fill = !!fill_var_enquo)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(labels = scales::percent_format(scale = 1)) +
    labs(
      title = titulo,
      x = x_label %||% rlang::as_label(x_var_enquo),
      y = y_label,
      fill = fill_label
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 7))
  
}
