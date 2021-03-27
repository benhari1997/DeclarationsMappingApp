# import essetial libraries 
library(shiny)
library(here)
library(DT)
library(leaflet)
library(dplyr)
library(sf)
library(ggplot2)
library(tidyverse)

# Load the data to the current environement
load(here("DeclarationsMappingApp/data/dansmarue.RData"))

#
# User interface : 
#
ui <- fluidPage(
  # a title
  titlePanel('Analyse des Declarations - Paris :'),
  # a theme
  shinythemes::shinytheme("paper") ,
  # organised un/outputs :
  sidebarLayout(
    sidebarPanel(
      selectInput('Type',"Type de declaration : ", choices = dansmarue %>% distinct(TYPE)),
      selectInput('p_code',"Code Postal :", choices = dansmarue %>% distinct(CODE_POSTAL)),
      dateRangeInput('date','Periode :',
                     start = min(dansmarue$DATEDECL), end = "2018-07-04",
                     min = min(dansmarue$DATEDECL), max = max(dansmarue$DATEDECL),
                     format = "yyyy-mm-dd")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel('Dispertion des declarations', leafletOutput('pts_map')),
        tabPanel('Densite des declarations', leafletOutput('circles_map')),
        tabPanel('Nombre de declarations', plotOutput("counts")),
        tabPanel('Data', DT::DTOutput('table'))
      )
    )
  )
)

#
# App Server (to collect user choices) : 
#
server <- function(input, output, session) {
  ## data update
  data_rue <- reactive(dansmarue[dansmarue$TYPE == input$Type,]%>% 
                         filter(as.double(DATEDECL) >= min(input$date),
                                as.double(DATEDECL) <= max(input$date),
                                CODE_POSTAL == input$p_code
                         )
  )
  data_rue.sf <- reactive(dansmarue.sf[dansmarue.sf$TYPE == input$Type,]%>% 
                            filter(as.double(DATEDECL) >= min(input$date),
                                   as.double(DATEDECL) <= max(input$date)  
                            )
  )
  
  densit <- reactive(sapply(st_contains( x=gr, y=data_rue.sf()$geometry), length))
  data_gr_p <- reactive(gr_p %>%  add_column(dens  = densit()))
  
  # output results 
  output$circles_map <- renderLeaflet(
    ## creates an interactive map
    leaflet(data=data_gr_p() %>% st_transform(4326)) %>% 
      addTiles() %>% 
      addCircleMarkers(radius =~ sqrt(dens/10)*1.5,
                       fillColor = "purple",
                       stroke = FALSE,
                       fillOpacity = 0.5,
                       popup = ~paste("Nombre de plaintes:",dens))
  )
  # creates an interactive table
  output$table <- DT::renderDT(
    data_rue()
  )
  # creates an interactive points-map
  output$pts_map <- renderLeaflet(
    
    leaflet(data = data_rue()) %>% 
      addTiles() %>% 
      addCircles(fillOpacity = 0.5)
  )
  # creates a statistical bar plot
  output$counts <- renderPlot(
    ggplot(data_rue() %>% count(TYPE, SOUSTYPE, DATEDECL) , aes(x = SOUSTYPE, y = n)) +
      geom_bar(stat = "identity", fill = "lightgrey")   +
      theme_minimal()+ 
      coord_flip() 
  )
  
}

# App execution 
shinyApp(ui = ui, server = server)
