
library(shiny)
library(leaflet)
devtools::load_all()

ui <- softui::simple_page(
  save_dom_element_dependencies(),
  
  softui::box(
    leafletOutput("map"),
    actionButton("btngone", "No zoom!"),
    actionButton("btngo", "Yes zoom!"),
  )
  
)

server <- function(input, output, session) {
  
  
  output$map <- renderLeaflet({
    leaflet() %>% addTiles() %>% addMarkers(data = data.frame(lat=0, lon=25))
  })
  
  observeEvent(input$btngone, {
    hide_leaflet_zoom()  
  })
  
  observeEvent(input$btngo, {
    show_leaflet_zoom()  
  })
}

shinyApp(ui, server)

