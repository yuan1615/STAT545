library(shiny)
library(ggplot2)
library(tidyverse)
library(colourpicker)  # 增加颜色输入
library(DT)

# ------ 拓展包 ----
library(shinyjs)  # JavaScript, 延迟几秒等作用....
library(leaflet)  # 创建一个单张地图小部件

library(shinydashboard) 
# 轻松构建仪表盘
# http://rstudio.github.io/shinydashboard/index.html

library(shinythemes) 
# 更改shiny的主题,比css文件更简单
# http://rstudio.github.io/shinythemes/

library(ggvis)
# 类似ggplot2,增强了网页的交互能力


bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  shinythemes::themeSelector(),  # <--- Add this somewhere in the UI
  img(src = "ceshi.jpg", width = 1500, height = 200),
  headerPanel("BC Liquor Store prices"),
  includeCSS("./www/main.css"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
      selectInput("typeInput", "Product type",
                  choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                  multiple = TRUE,
                  selected = c("WINE", "BEER")),
      conditionalPanel(
        condition = "input.typeInput == 'WINE'",
        uiOutput("sweetOutput")
      ),
      
      uiOutput("countryOutput"),
      checkboxInput("PriceOrder", "Order by Price", value = TRUE),
      colourpicker::colourInput("colour", "Choose the colour", value = "#616161")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("coolplot")),
        
        tabPanel("Tabel", h2(textOutput("nresults")),
                 downloadButton("downloadData", "Download the Data"),
                 DT::dataTableOutput("results")),
        tabPanel("Map", leafletOutput("map") )
      )
      
    )
  )
)


server <- function(input, output) {
  
  filtered <- reactive({
    
    if(any(is.null(input$countryInput) | 
           (is.null(input$sweetInput) & input$typeInput == "WINE") | 
           is.null(input$typeInput))) {
      return(NULL)
    }
    
    if(all(input$typeInput == "WINE")){
      bcl %>%
        filter(Price >= input$priceInput[1],
               Price <= input$priceInput[2],
               Type %in% input$typeInput,
               Country == input$countryInput,
               Sweetness == input$sweetInput
        )
    }else{
      bcl %>%
        filter(Price >= input$priceInput[1],
               Price <= input$priceInput[2],
               Type %in% input$typeInput,
               Country == input$countryInput
        )
    }

  })
  
  output$coolplot <- renderPlot({
    # 解决刚输入问题
    if (is.null(filtered())) {
      return()
    }
    if(nrow(filtered()) == 0){
      return(NULL)
    }
    ggplot(filtered(), aes(Alcohol_Content)) +
      geom_histogram(fill = input$colour)
  })
  
  output$results <- DT::renderDataTable({
    if (is.null(filtered())) {
      return()
    }
    if(nrow(filtered()) == 0){
      return(NULL)
    }
    if(input$PriceOrder == TRUE){
      filtered() %>% 
        arrange(desc(Price))
    }else{
      filtered()
    }
    
  })
  output$nresults <- renderText({
    if (is.null(filtered())) {
      return()
    }
    n <- filtered() %>% nrow()
    print(paste("We found ", n, "options for you"))
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(filtered(), file)
    }
  )
  
  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
                sort(unique(bcl$Country)),
                selected = "CANADA")
  })

  output$sweetOutput <- renderUI({
    selectInput("sweetInput", "Sweet",
                sort(unique(bcl$Sweetness), na.last = TRUE),
                selected = "1")
  })
  
  output$map <- renderLeaflet({
    m <- leaflet() %>% addTiles() %>% 
      setView(121.2046480178833, 31.057090659625004, zoom = 15)
    m
  })
  
}

shinyApp(ui = ui, server = server)


