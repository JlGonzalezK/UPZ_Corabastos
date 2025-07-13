# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.
# CC BY-NC-SA 4.0.

# grafico de barras facetado
grafico_faceta <- function(tabla, 
                           titulo = "Distribución proporcional por subgrupo",
                           x_label = "Grupo etario",
                           y_label = "Proporción (%)",
                           fill_label = "Nivel educativo",
                           facet_label = "Sexo") {
  ggplot(tabla, aes(x = x, y = pct, fill = fill)) +
    geom_bar(stat = "identity", position = "stack") +
    facet_wrap(~ facet) +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(
      title = titulo,
      x     = x_label,
      y     = y_label,
      fill  = fill_label
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1, size = 5),
      strip.text  = element_text(face = "bold")
    )
}


# proporciones cruzadas
grafico_proporciones_cruzadas <- function(
    data, 
    x_var, 
    fill_var, titulo = "Distribución proporcional", 
    x_label = NULL, 
    y_label = "Proporción (%)", 
    fill_label = "Categoría") {
  x_enquo    <- rlang::enquo(x_var)
  fill_enquo <- rlang::enquo(fill_var)
  
  x_label    <- x_label     %||% rlang::as_label(x_enquo)
  fill_label <- fill_label  %||% rlang::as_label(fill_enquo)
  
  data %>%
    dplyr::filter(!is.na(!!x_enquo), !is.na(!!fill_enquo)) %>%
    dplyr::mutate(x = haven::as_factor(!!x_enquo),
                  fill = haven::as_factor(!!fill_enquo)) %>%
    dplyr::count(x, fill) %>%
    dplyr::group_by(x) %>%
    dplyr::mutate(pct = round(n / sum(n), 3)) %>%
    ggplot(aes(x = x, 
               y = pct, 
               fill = fill)) +
    geom_bar(stat = "identity", position = "fill") +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(title = titulo, x = x_label, y = y_label, fill = fill_label) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, 
                                     hjust = 1, 
                                     size = 7))
}
