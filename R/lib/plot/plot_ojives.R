# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.
# CC BY-NC-SA 4.0.

# Gráfico de curva
grafico_curva_valores <- function(
    data,
    x_var,
    y_var,
    titulo      = "Curva por grupo",
    x_label     = NULL,
    y_label     = "Valor medio",
    color_line  = "#5482F3",
    color_punto = "#E490D6"
) {
  x_var_enquo <- rlang::enquo(x_var)
  y_var_enquo <- rlang::enquo(y_var)
  
  ggplot(data, aes(x = !!x_var_enquo, y = !!y_var_enquo, group = 1)) +
    geom_line(color  = color_line, linewidth = 1) +
    geom_point(color = color_punto, size = 2) +
    labs(
      title = titulo,
      x = x_label %||% rlang::as_label(x_var_enquo),
      y = y_label
    ) +
    scale_y_continuous(breaks = scales::breaks_width(1.25)) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 7))
}

# grafico ojiva segmentado
grafico_ojiva_faceta <- function(
    data, 
    edad, 
    sexo, 
    grado,
    titulo = "ojiva acumulada") {
  edad_enquo  <- rlang::enquo(edad)
  sexo_enquo  <- rlang::enquo(sexo)
  grado_enquo <- rlang::enquo(grado)
  
  data %>%
    dplyr::filter(
      !is.na(!!edad_enquo),
      !is.na(!!sexo_enquo),
      !is.na(!!grado_enquo)
    ) %>%
    dplyr::filter(!!grado_enquo != 99) %>%
    dplyr::mutate(
      edad  = haven::as_factor(!!edad_enquo),
      sexo  = haven::as_factor(!!sexo_enquo),
      grado = haven::as_factor(!!grado_enquo)
    ) %>%
    dplyr::group_by(edad, sexo, grado) %>%
    dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
    dplyr::group_by(edad, sexo) %>%
    dplyr::arrange(grado) %>%
    dplyr::mutate(
      p    = n / sum(n),
      acum = cumsum(p)
    ) %>%
    ggplot2::ggplot(aes(x = grado, y = acum, color = sexo, group = sexo)) +
    ggplot2::geom_smooth(se = FALSE, method = "loess", span = 1) +
    ggplot2::facet_wrap(~ edad) +
    ggplot2::scale_y_continuous(labels = scales::percent_format()) +
    ggplot2::ggtitle(titulo) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x  = ggplot2::element_blank()) +
    scale_color_manual(values = c("Hombre" = "#5482F3", "Mujer" = "#E490D6"))
}

# Gráfico de proporciones facetado
grafico_faceta <- function(tabla, 
                                titulo = "Distribución proporcional por subgrupo",
                                x_label = "Grupo etario",
                                y_label = "Proporción (%)",
                                fill_label = "leyenda",
                                facet_label = "faceta") {
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
      axis.text.x = element_text(angle = 45, hjust = 1, size = 7),
      strip.text  = element_text(face = "bold")
    )
}
