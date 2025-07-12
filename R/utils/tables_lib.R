# tables library (v0.07)
# CC BY-NC-SA 4.0.
# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.

# tabla de población detallada
tabla_poblacion_sexo <- function(data, var_edad = P_EDADR, var_sexo = P_SEXO) {
  data %>%
    count(rango_edad = haven::as_factor({{ var_edad }}), sexo = {{ var_sexo }}) %>%
    pivot_wider(names_from = sexo, values_from = n, values_fill = 0) %>%
    transmute(
      rango_edad,
      Hombres = `1`,
      Mujeres = `2`,
      Total = Hombres + Mujeres,
      Porcentaje = round((Total / sum(Total)) * 100, 2),
      Masculinidad = if_else(Mujeres > 0, round(Hombres / Mujeres * 100, 1), 
                             NA_real_),
      Feminidad = if_else(Hombres > 0, round(Mujeres / Hombres * 100, 1), 
                          NA_real_)
    ) %>%
    arrange(rango_edad)
}

# Tabla de fecundidad detallada
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
    mutate(!!rlang::as_name(variable_hijos_enquo) := na_if(!!variable_hijos_enquo, 99)) %>%
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
      fecundidad_media = round(hijos_totales / mujeres, 2)
    ) %>%
    arrange(grupo_edad)
}
