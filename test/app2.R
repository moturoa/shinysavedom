
library(shinysavedom)

library(shiny)
library(leaflet)
library(glue)
library(magick)


testModuleUI <- function(id){
  ns <- NS(id)

  tagList(
    shinysavedom::save_dom_element_dependencies(),

    fluidRow(
      column(6,
             leafletOutput(ns("leaf"), width = 600, height = 600),
             actionButton(ns("btn"),"Snap!")
      ),
      column(6,

             imageOutput(ns("img_out"), height = 200, width = 200)
      )
    )
  )

}

testModule <- function(input, output, session){

  output$leaf <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = data.frame(lon = 5.1, lat = 52.1))
  })

  observeEvent(input$btn, {
    save_dom_element("leaf", "leaf_out")
  })


  output$img_out <- renderImage({

    mybase64 <- input$leaf_out$dataUrl
    req(mybase64)

    fn <- shinysavedom::to_png(mybase64, resize = "50%")



    list(src=fn)

  }, deleteFile = TRUE)
}



ui <- fluidPage(

  testModuleUI("test")

)



server <- function(input, output, session) {

 callModule(testModule, "test")

}

shinyApp(ui, server)

