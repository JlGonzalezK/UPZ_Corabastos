# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.
# CC BY-NC-SA 4.0. 
# v0.02

viz_leaflet <- function(layer1 = NULL, layer2 = NULL, layer3 = NULL,
                        names = c("Capa 1", "Capa 2", "Capa 3"),
                        fill_colors = c("#2962FF", "#00FFAC", "#FF5722"),
                        stroke_colors = c("#2962FF", "#00FFAC", "#FF5722"),
                        weights = c(4, 2, 2),
                        popup_cols = c(NULL, NULL, NULL)) {
  
  bbox_list <- list()
  overlay_groups <- c()
  legend_colors  <- c()
  legend_labels  <- c()
  
  m <- leaflet(options = leafletOptions(preferCanvas = TRUE)) %>%
    addProviderTiles("CartoDB.DarkMatter", group = "Modo oscuro") %>%
    addProviderTiles("Esri.WorldImagery", group = "Satélite") %>%
    addProviderTiles("OpenStreetMap.Mapnik", group = "OSM")
  
  # Función modificada para incluir popups
  add_layer <- function(layer, name, fill_col, stroke_col, weight, popup_col) {
    # Crear contenido para popup si se especifica columna
    popup_content <- NULL
    if (!is.null(popup_col) && popup_col %in% names(layer)) {
      popup_content <- paste0(
        "<strong>Capa: ", name, "</strong><br>",
        "<strong>Selección:</strong> ", str_to_title(as.character(layer[[popup_col]]))
      )
    } else {
      NULL
    }
    
    m <<- m %>% addPolygons(
      data        = layer,
      fillColor   = fill_col,
      fillOpacity = 0.6,
      color       = stroke_col,
      weight      = weight,
      group       = name,
      popup       = popup_content
    )
    overlay_groups <<- c(overlay_groups, name)
    legend_colors  <<- c(legend_colors, fill_col)
    legend_labels  <<- c(legend_labels, name)
    bbox_list[[length(bbox_list)+1]] <<- st_bbox(layer)
  }
  
  # Aplicar popups a cada capa
  if (!is.null(layer1)) add_layer(layer1, 
                                  names[1], 
                                  fill_colors[1], 
                                  stroke_colors[1], 
                                  weights[1], 
                                  popup_cols[[1]])
  
  if (!is.null(layer2)) add_layer(layer2, 
                                  names[2], 
                                  fill_colors[2], 
                                  stroke_colors[2], 
                                  weights[2], 
                                  popup_cols[[2]])
  
  if (!is.null(layer3)) add_layer(layer3, 
                                  names[3], 
                                  "transparent", 
                                  stroke_colors[3], 
                                  weights[3], 
                                  popup_cols[[3]])
  
  # Centrado inicial en layer1
  if (!is.null(layer1)) {
    bounds <- st_bbox(layer1)
    
    m <- m %>% fitBounds(
      lng1 = bounds[["xmin"]],
      lat1 = bounds[["ymin"]],
      lng2 = bounds[["xmax"]],
      lat2 = bounds[["ymax"]]
    )
    
    # Botón de centrado
    m <- m %>%
      addEasyButton(
        easyButton(
          icon = "fa-crosshairs", 
          title = "Centrar (filtro)",
          onClick = JS(sprintf(
            "function(btn, map){ map.fitBounds([[%.6f, %.6f],[%.6f, %.6f]]); }",
            bounds[["ymin"]], bounds[["xmin"]], 
            bounds[["ymax"]], bounds[["xmax"]]
          ))
        )
      )
  }
  
  # Resto del código
  m %>%
    addLayersControl(
      baseGroups    = c("Modo oscuro", "OSM", "Satélite"),
      overlayGroups = overlay_groups,
      options       = layersControlOptions(collapsed = FALSE)
    ) %>%
    addLegend(
      position = "bottomright",
      colors   = legend_colors,
      labels   = legend_labels,
      title    = "Leyenda",
      opacity  = 1
    )
}
