
library(shinysavedom)

library(shiny)
library(leaflet)
library(glue)
library(magick)
library(shinyjs)

ui <- fluidPage(
  shinysavedom::save_dom_element_dependencies(),
  useShinyjs(),

  fluidRow(
    column(6,
           leafletOutput("leaf", width = 600, height = 600),
           actionButton("btn","Snap!")
    ),
    column(6,

           imageOutput("img_out", height = 200, width = 200),
           tags$hr(),
           actionButton("btn_download_img","Download"),
           tags$div(style="height: 200px;"),
           uiOutput("ui_img_out")
    )
  )

)

server <- function(input, output, session) {

  
  observeEvent(input$btn_download_img, {
    download_dom_element("img_out", "testimageout")
  })
  
  output$leaf <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = data.frame(lon = 5.1, lat = 52.1)) %>%
      addLegend(colors = c("blue","red"), labels = LETTERS[1:2],
                layerId = "maplegendleaflet")
  })

  observeEvent(input$btn, {
    runjs("hide_leaflet_zoom();")
    save_dom_element("leaf", "leaf_out")
    runjs("show_leaflet_zoom();")
  })

  output$img_out <- renderImage({

    mybase64 <- input$leaf_out$dataUrl
    req(mybase64)

    fn <- shinysavedom::to_png(mybase64, resize = "50%")

    list(src=fn)

  }, deleteFile = TRUE)

  output$ui_img_out <- renderUI({
    mybase64 <- input$leaf_out$dataUrl
    req(mybase64)
    HTML(glue('<img src="{mybase64}" alt="base64 image here" />'))
  })

}

shinyApp(ui, server)

