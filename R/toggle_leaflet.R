#' Hide or show leaflet control buttons
#' @description When saving a leaflet map, use these functions to first remove (and then add) the control
#' buttons, so they do not appear in the screenshot
#' @export
#' @rdname hide_leaflet_zoom
hide_leaflet_zoom <- function(session = shiny::getDefaultReactiveDomain()){
  
  session$sendCustomMessage("hide_leaflet_zoom", list(id = "all"))
  
}

#' @export
#' @rdname hide_leaflet_zoom
show_leaflet_zoom <- function(session = shiny::getDefaultReactiveDomain()){
  
  session$sendCustomMessage("show_leaflet_zoom", list(id = "all"))
  
}

