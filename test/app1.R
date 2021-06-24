
library(shinysavedom)

library(shiny)
library(leaflet)
library(glue)
library(magick)

ui <- fluidPage(
  shinysavedom::save_dom_element_dependencies(),

  fluidRow(
    column(6,
           leafletOutput("leaf", width = 600, height = 600),
           actionButton("btn","Snap!")
    ),
    column(6,

           imageOutput("img_out", height = 200, width = 200)
    )
  )

)

server <- function(input, output, session) {

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

shinyApp(ui, server)

