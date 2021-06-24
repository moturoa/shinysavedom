#' Save DOM element shiny dependencies
#' @importFrom htmltools htmlDependency
#' @export
save_dom_element_dependencies <- function(tag){

  list(
    htmltools::htmlDependency(name = "savedom-assets",
                              version = "0.1",
                              package = "shinysavedom",
                              src = "assets",
                              script = "savedom/savedom.js"
    ),
    htmltools::htmlDependency(name = "domtoimage",
                              version = "0.1",
                              package = "shinysavedom",
                              src = "assets",
                              script = "domtoimage/dom-to-image.js"
    )
  )
}

