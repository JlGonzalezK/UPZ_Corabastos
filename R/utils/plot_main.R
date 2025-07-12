# plots main library (v0.07)
# CC BY-NC-SA 4.0.
# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.

grafico_por_etapa_sociologica <- function(
    data, 
    variable, 
    titulo = "Distribución por etapa sociológica", 
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
      ),
      etapa_vida = factor(etapa_vida, levels = c(
        "Primera infancia", "Infancia", "Adolescencia",
        "Juventud", "Adultez", "Vejez"
      )),
      categoria = haven::as_factor({{ variable }})
    ) %>%
    count(etapa_vida, categoria) %>%
    group_by(etapa_vida) %>%
    mutate(pct = round(n / sum(n) * 100, 1)) %>%
    ggplot(aes(x = etapa_vida, y = pct, fill = categoria)) +
    geom_bar(stat = "identity", position = "fill") +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(
      x = "Etapa sociológica",
      y = "Proporción (%)",
      fill = fill_label,
      title = titulo
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

grafico_por_edad_etiquetada <- function(
    data, 
    variable, 
    titulo = "Distribución por grupo de edad", 
    fill_label = "Categoría") {
  data %>%
    filter(!is.na(P_EDADR), !is.na({{ variable }})) %>%
    mutate(
      edad = haven::as_factor(P_EDADR),
      categoria = haven::as_factor({{ variable }})
    ) %>%
    count(edad, categoria) %>%
    group_by(edad) %>%
    mutate(pct = round(n / sum(n) * 100, 1)) %>%
    ggplot(aes(x = edad, y = pct, fill = categoria)) +
    geom_bar(stat = "identity", position = "fill") +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(
      x = "Grupo etario (CNPV)",
      y = "Porcentaje (%)",
      fill = fill_label,
      title = titulo
    ) +
    theme_minimal() + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# 3. Gráfico cruzado entre dos variables categóricas
grafico_proporciones_cruzadas <- function(data, x_var, fill_var,
                                          titulo = "Distribución cruzada",
                                          fill_label = "Categoría",
                                          x_label = NULL) {
  
  x_var_enquo   <- rlang::enquo(x_var)
  fill_var_enquo <- rlang::enquo(fill_var)
  
  etiqueta_x <- x_label %||% attr(data[[rlang::as_name(x_var_enquo)]], "label")
  
  data %>%
    filter(!is.na(!!x_var_enquo), !is.na(!!fill_var_enquo)) %>%
    mutate(
      x    = haven::as_factor(!!x_var_enquo),
      fill = haven::as_factor(!!fill_var_enquo)
    ) %>%
    count(x, fill) %>%
    group_by(x) %>%
    mutate(pct = round(n / sum(n) * 100, 1)) %>%
    ggplot(aes(x = x, y = pct, fill = fill)) +
    geom_bar(stat = "identity", position = "fill") +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(
      x = etiqueta_x,
      y = "Proporción (%)",
      fill = fill_label,
      title = titulo
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# gráfico para valores agrupado
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
  
  ggplot(data, aes(x = !!x_var_enquo, y = !!y_var_enquo, fill = !!fill_var_enquo)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(breaks = seq(0, 5, 0.5)) +
    labs(
      title = titulo,
      x = x_label %||% rlang::as_label(x_var_enquo),
      y = y_label,
      fill = fill_label
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
}

# gráfico de curva para valores agrupados
grafico_curva_valores_agrupados <- function(
    data,
    x_var,
    y_var,
    titulo     = "Curva por grupo",
    x_label    = NULL,
    y_label    = "Valor medio",
    color_line = "#5482F3",
    color_punto = "#E490D6"
) {
  x_var_enquo <- rlang::enquo(x_var)
  y_var_enquo <- rlang::enquo(y_var)
  
  ggplot(data, aes(x = !!x_var_enquo, y = !!y_var_enquo, group = 1)) +
    geom_line(color = color_line, linewidth = 1) +
    geom_point(color = color_punto, size = 2) +
    labs(
      title = titulo,
      x = x_label %||% rlang::as_label(x_var_enquo),
      y = y_label
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}
