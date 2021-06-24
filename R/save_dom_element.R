#' Save a DOM element in a Shiny app to a PNG
#' @param id Shiny input ID of element to take a snapshot of
#' @param id_out Snapshot will become available as this input ID (e.g. input$myelement)
#' @importFrom shiny getDefaultReactiveDomain
#' @export
save_dom_element <- function(id, id_out, session = shiny::getDefaultReactiveDomain()){

  session$sendCustomMessage("save_dom_element",
                            list(id = session$ns(id),
                                 id_out = session$ns(id_out)))

}
