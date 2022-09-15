#' Download a DOM element in a Shiny app to a PNG
#' @param id Shiny input ID of element to take a snapshot of
#' @param name Name of output file (without extension)
#' @importFrom shiny getDefaultReactiveDomain
#' @export
download_dom_element <- function(id, name,
                             session = shiny::getDefaultReactiveDomain(),
                             asis = FALSE){
  
  if(!asis){
    id <- session$ns(id)
  }
  
  session$sendCustomMessage("download_dom_element",
                            list(id = id,
                                 name = name))
  
}
