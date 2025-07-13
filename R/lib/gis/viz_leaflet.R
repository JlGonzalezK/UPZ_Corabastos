# Jorge Luis González-Castellanos <jlgonzalezca@unal.edu.co>, 2025.
# CC BY-NC-SA 4.0.

viz_leaflet <- function(layer1 = NULL, layer2 = NULL, layer3 = NULL,
                        names = c("Capa 1", "Capa 2", "Capa 3"),
                        fill_colors = c("#2962FF", "#00FFAC", "#FF5722"),
                        stroke_colors = c("#2962FF", "#00FFAC", "#FF5722"),
                        weights = c(4, 2, 2)) {
  
  bbox_list <- list()
  overlay_groups <- c()
  legend_colors  <- c()
  legend_labels  <- c()
  
  m <- leaflet(options = leafletOptions(preferCanvas = TRUE)) %>%
    addProviderTiles("CartoDB.DarkMatter", group = "Fondo oscuro") %>%
    addProviderTiles("Esri.WorldImagery", group = "Satélite") %>%
    addProviderTiles("OpenStreetMap.Mapnik", group = "OSM")
  
  add_layer <- function(layer, name, fill_col, stroke_col, weight) {
    m <<- m %>% addPolygons(
      data        = layer,
      fillColor   = fill_col,
      fillOpacity = 0.6,
      color       = stroke_col,
      weight      = weight,
      group       = name
    )
    overlay_groups <<- c(overlay_groups, name)
    legend_colors  <<- c(legend_colors, fill_col)
    legend_labels  <<- c(legend_labels, name)
    bbox_list[[length(bbox_list)+1]] <<- st_bbox(layer)
  }
  
  if (!is.null(layer1)) add_layer(layer1, names[1], fill_colors[1], stroke_colors[1], weights[1])
  if (!is.null(layer2)) add_layer(layer2, names[2], fill_colors[2], stroke_colors[2], weights[2])
  if (!is.null(layer3)) add_layer(layer3, names[3], "transparent", stroke_colors[3], weights[3])
  
  bounds <- NULL
  if (length(bbox_list) > 0) {
    total_bbox <- do.call(rbind, bbox_list) %>% as.data.frame()
    bounds <- c(min(total_bbox$xmin), min(total_bbox$ymin),
                max(total_bbox$xmax), max(total_bbox$ymax))
  }
  
  if (!is.null(bounds)) {
    m <- m %>%
      addEasyButton(
        easyButton(
          icon = "fa-crosshairs", title = "Centrar capas",
          onClick = JS(sprintf(
            "function(btn, map){ map.fitBounds([[%.6f, %.6f],[%.6f, %.6f]]); }",
            bounds[2], bounds[1], bounds[4], bounds[3]
          ))
        )
      )
  }
  
  m %>%
    addLayersControl(
      baseGroups    = c("Fondo oscuro", "OSM", "Satélite"),
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
