
library(shinysavedom)

library(shiny)
library(leaflet)
library(glue)
library(magick)
library(shinyjs)

library(ggplot2)
library(plotly)


ui <- fluidPage(
  shinysavedom::save_dom_element_dependencies(),
  useShinyjs(),

  fluidRow(
    column(6,

         tabsetPanel(
           tabPanel("leaflet",
                    leafletOutput("leaf", width = 600, height = 600),
                    actionButton("btn1","Snap!", icon = icon("camera")),

                    ),
           tabPanel(
             "plot",
             plotOutput("plot1", width = 600, height = 600),
             actionButton("btn2","Snap!", icon = icon("camera"))
           ),
           tabPanel(
             "plotly",
             plotlyOutput("plotly1", width = 600, height = 600),
             actionButton("btn3","Snap!", icon = icon("camera"))
           )
         )

    ),
    column(6,

           tags$div(id = "image_placeholder")
           #imageOutput("img_out", height = 200, width = 200)
    )
  )

)

server <- function(input, output, session) {

  output$leaf <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = data.frame(lon = 5.1, lat = 52.1)) %>%
      addLegend(colors = c("blue","red"), labels = LETTERS[1:2],
                layerId = "maplegendleaflet")
  })

  observeEvent(input$btn1, {
    runjs("hide_leaflet_zoom();")
    save_dom_element("leaf", "picture_out")
    runjs("show_leaflet_zoom();")
  })

  observeEvent(input$btn2, {
    save_dom_element("plot1", "picture_out")
  })

  observeEvent(input$btn3, {
    save_dom_element("plotly1", "picture_out")
  })


  output$plot1 <- renderPlot({

    ggplot(mtcars, aes(x = disp,y = wt)) +
      geom_point()

  })


  output$plotly1 <- renderPlotly({

    p <- ggplot(mtcars, aes(x = disp,y = wt)) +
      geom_point()

    ggplotly(p)

  })

  observeEvent(input$picture_out, {

    fn <- shinysavedom::to_png(input$picture_out$dataUrl, resize = "50%")

    new_id <- uuid::UUIDgenerate()
    btn_id <- paste0("button-",new_id)
    box_id <- paste0("box-",new_id)

    ui <- tags$div(id = box_id,
      style = "padding: 30px; margin: 30px; border: 1px solid #999",
      tags$div(style = "width: 100%",
          tags$div(style = "float:right;",

                   actionButton(session$ns(btn_id), "", icon = icon("remove"))

          )
      ),
      imageOutput(session$ns(new_id))
    )

    insertUI("#image_placeholder", where = "afterBegin", ui = ui)

    observeEvent(input[[btn_id]], {

      removeUI(paste0("#",box_id))

    })

    output[[new_id]] <- renderImage({

      mybase64 <- isolate(input$picture_out$dataUrl)
      req(mybase64)

      fn <- shinysavedom::to_png(mybase64, resize = "50%")

      list(src=fn)

    }, deleteFile = TRUE)

  })







}

shinyApp(ui, server)

