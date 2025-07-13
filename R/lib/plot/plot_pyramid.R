# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.
# CC BY-NC-SA 4.0.

# 1. Pirámide poblacional
piramide_pob <- function(dataset, age, gender, title = "Pirámide Poblacional CNPV 2018") {
  
  age_sym    <- ensym(age)
  gender_sym <- ensym(gender)
  
  cnpv_piramide <- dataset %>%
    count(
      edad = to_factor(!!age_sym),
      sexo = to_factor(!!gender_sym)
    ) %>%
    mutate(population = n / sum(n) * 100) %>%
    select(edad, sexo, population)
  
  ggplot(cnpv_piramide, aes(x = edad, fill = sexo,
                            y = if_else(sexo == "Hombre", -population, population))) +
    geom_bar(stat = "identity", width = 1, color = "#D9EBE8", linewidth = 0.2) +
    geom_text(aes(label = paste0(round(population, 1), "%"),
                  y = if_else(sexo == "Hombre", -population - 0.5, population + 0.5),
                  hjust = if_else(sexo == "Hombre", 1, 0)),
              size = 3, color = "#282C2B") +
    scale_y_continuous(labels = abs, limits = c(-8, 8)) +
    labs(title = title,
         x = "Grupo de edad", y = "Porcentaje de la población") +
    scale_colour_manual(values = c(Hombre = "#5482F3", Mujer = "#E490D6"),
                        aesthetics = c("fill", "colour")) + 
    theme_classic() +
    theme(
      plot.title = element_text(hjust = 0.5, margin = margin(b = 20))
    ) +
    coord_flip()
}
