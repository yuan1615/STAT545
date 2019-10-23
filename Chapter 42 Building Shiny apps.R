# 要点
# 利用shiny建立交互式网页

# 主要函数:

# *************************** ui 函数 ********************************
# fluidPage:创建一个流动布局的页面
# titlePanel:创建包含应用程序标题的面板
# sidebarLayout:布局一个侧边栏(sidebarPanel)和主要区域(mainPanel)
# conditionalPanel():有条件的显示面板
# navbarPage()/tabsetPanel():构建多个界面选项


# h1:顶级标题的功能
# h2:用于辅助标头
# strong:使文本加粗
# em:使文本变为斜体
# ............


# textInput()用于让用户输入文本
# numericInput()让用户选择数字
# dateInput()用于选择日期
# selectInput()用于创建选择框（又称下拉菜单）
# sliderInput:滑窗,返回两个数字
# radioButtons:单选框
# ......


# plotOutput("占位符"),
# tableOutput("占位符")
# ......


# ************************** server函数 ***********************************
# renderPlot:呈现适合分配给输出槽的反应性绘图
# renderTable:创建适合分配给输出槽的反应性表
# renderText:
# render*/reactive({})/observe({})


# !!!!!!!!!!!!!!!!!!!!!!!!!!!一些重要说明!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#-==================  1 ====================
# Shiny使用称为反应式编程的概念。这就是使您的输出对输入变化做出反应的原因。
# Shiny中的反应性很复杂，但是作为一种极端的过分简化，这意味着当变量的值x更改时，
# 所有依赖的内容x都会重新评估
# 例如：
x <- 5
y <- x + 1
x <- 10
# 这个时候在shiny中 y = 11,而不是6!!!!!!!!!!!!!!!

# 反应变量与server中的块儿相连,当一个反应改变时,整个都会重新计算
# 例如：
# output$someoutput <- renderPlot({
#   col <- input$mycolour
#   num <- input$mynumber
#   plot(rnorm(num), col = col)
# })
# 上例有两个反应变量,当任意一个改变时,都会重新画图.

#-==================  2 ====================
# input$中的东西,仅仅能出现在反应式中
# 即render*/reactive({})/observe({})
# 例如：
# print要放到observe({})里才能正常执行

# !!!!! reactive({}) !!!!!!

# 如果要自己定义反应变量，一定要放到reactive({})中
# 例如：
# priceDiff <- reactive({
#   diff(input$priceInput)
# })

# 而且不能直接访问priceDiff,必须要加(),即priceDiff(),此时将它当成了一个函数！

# 创建反应变量还可以减少代码的重复！

#-==================  3  ====================
# 使用uiOutput()动态创建UI元素
# 您通常在UI中创建的所有输入都会在应用启动时创建，并且无法更改。
# 但是，如果您的输入之一依赖于另一输入怎么办？在这种情况下，
# 您希望能够在服务器中动态创建输入，并且可以使用uiOutput()
# uiOutput("占位符")/ output$占位符 <- renderUI({})
# 例子：
# 我们在构建国家下拉框的时候就可以使用,通过数据反应出下拉框国家个数

##-==================  4  ====================
# DT 包，构建简洁漂亮的表格
# DT::dataTableOutput()/DT::renderDataTable()

##-==================  5  ====================
# 当您在反应式上下文中有多个反应式变量时，只要任何反应式变量发生更改，
# 整个代码块都会重新执行，因为所有变量都成为代码的依赖项。
# 如果要抑制此行为并导致反应变量不是依赖项，
# 则可以在isolate()函数中包装使用该变量的代码

##-==================  6  ====================
# 使用update*Input()功能以编程方式更新输入值
# UI中input是相互关联的

##-==================  7  ====================
#  Shiny应用程序中的作用域规则可以开发针对不同用户的不同功能


##################### Chapter 42 Building Shiny apps #####################

# 原作者shiny服务器
# https://daattali.com/shiny/

# shiny官方案例
# https://shiny.rstudio.com/tutorial/

# shiny备忘录
# https://shiny.rstudio.com/images/shiny-cheatsheet.pdf

#------ 42.1 Before we begin ------
library(shiny)
runExample("01_hello")

# 用户个人提交的shiny案例
# https://www.showmeshiny.com/

#------ 42.2 Shiny app basics ------
# 两部分：它们分别称为UI（用户界面）和 server

#------ 42.3 Create an empty Shiny app ------

# ui <- fluidPage()
# server <- function(input, output) {}
# shinyApp(ui = ui, server = server)

setwd("./Chapter 42 Shiny")

# runApp()   #可以启动项目

#---- 42.3.1 Alternate way to create a Shiny app: separate UI and server files ----

# 定义Shiny应用程序的另一种方法是将UI和服务器代码分成两个文件：ui.R和server.R


#---- 42.3.2 Let RStudio fill out a Shiny app template for you ----
# File > New File > Shiny Web App…. 

#------ 42.4 Load the dataset ------

#------ 42.5 Build the basic UI ------

#---- 42.5.1 Add plain text to the UI ----

#---- 42.5.2 Add formatted text and other HTML elements ----
# h1()顶级标题的功能（<h1>HTML）
# h2()用于辅助标头（<h2>HTML中）
# strong()使文本加粗（<strong>以HTML格式）
# em()使文本变为斜体（<em>HTML）
# ............还有很多

#---- 42.5.3 Add a title ----
# titlePanel()

#---- 42.5.4 Add a layout ----


#---- 42.5.5 All UI functions are simply HTML wrappers ----
# 所有UI功能都只是HTML包装器

#------ 42.6 Add inputs to the UI ------
# 将输入添加到UI

# 输入是使用户能够与Shiny应用程序进行交互的方式：
# textInput()用于让用户输入文本
# numericInput()让用户选择数字
# dateInput()用于选择日期
# selectInput()用于创建选择框（又称下拉菜单）
# ......

# 两个主要参数inputId(索引)和label(UI界面显示文字)：

#---- 42.6.1 Input for price ----

#---- 42.6.2 Input for product type ----

#---- 42.6.3 Input for country ----


#------ 42.7 Add placeholders for outputs ------
# 我们仍仅在构建UI，因此，此时我们只能为输出添加占位符，
# 该占位符将确定输出将在何处以及其ID是什么，但实际上不会显示任何内容。


#---- 42.7.1 Output for a plot of the results ----

#---- 42.7.2 Output for a table summary of the results ----

#------ 42.8 Checkpoint: what our app looks like after implementing the UI ------
# library(shiny)
# bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
# 
# ui <- fluidPage(
#   titlePanel("BC Liquor Store prices"),
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
#       radioButtons("typeInput", "Product type",
#                    choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
#                    selected = "WINE"),
#       selectInput("countryInput", "Country",
#                   choices = c("CANADA", "FRANCE", "ITALY"))
#     ),
#     mainPanel(
#       plotOutput("coolplot"),
#       br(), br(),
#       tableOutput("results")
#     )
#   )
# )
# 
# server <- function(input, output) {}
# 
# shinyApp(ui = ui, server = server)

#------ 42.9 Implement server logic to create outputs ------
# input 和 output

#---- 42.9.1 Building an output ----
# 1.将输出对象保存到output列表中（记住应用程序模板-每个服务器功能都有一个output参数）。
# 2.使用render*函数构建对象，其中*的输出类型为。
# 3.使用input列表访问输入值（每个服务器函数都有一个input参数）

#---- 42.9.2 Making an output react to an input ----

#---- 42.9.3 Building the plot output ----
# library(shiny)
# library(ggplot2)
# library(dplyr)
# 
# bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
# 
# ui <- fluidPage(
#   titlePanel("BC Liquor Store prices"),
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
#       radioButtons("typeInput", "Product type",
#                    choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
#                    selected = "WINE"),
#       selectInput("countryInput", "Country",
#                   choices = c("CANADA", "FRANCE", "ITALY"))
#     ),
#     mainPanel(
#       plotOutput("coolplot"),
#       br(), br(),
#       tableOutput("results")
#     )
#   )
# )
# 
# server <- function(input, output) {
#   output$coolplot <- renderPlot({
#     filtered <-
#       bcl %>%
#       filter(Price >= input$priceInput[1],
#              Price <= input$priceInput[2],
#              Type == input$typeInput,
#              Country == input$countryInput
#       )
#     ggplot(filtered, aes(Alcohol_Content)) +
#       geom_histogram()
#   })
# }
# 
# shinyApp(ui = ui, server = server)


#---- 42.9.4 Building the table output ----



#------ 42.10 Reactivity 101 ------
# Shiny使用称为反应式编程的概念。这就是使您的输出对输入变化做出反应的原因。
# Shiny中的反应性很复杂，但是作为一种极端的过分简化，这意味着当变量的值x更改时，
# 所有依赖的内容x都会重新评估
# 例如：
x <- 5
y <- x + 1
x <- 10
# 这个时候在shiny中 y = 11,而不是6!!!!!!!!!!!!!!!

# 反应变量与server中的块儿相连,当一个反应改变时,整个都会重新计算
# 例如：
# output$someoutput <- renderPlot({
#   col <- input$mycolour
#   num <- input$mynumber
#   plot(rnorm(num), col = col)
# })

# 上例有两个反应变量,当任意一个改变时,都会重新画图.

#---- 42.10.1 Creating and accessing reactive variables ----
# input$中的东西,仅仅能出现在反应式中
# 即render*/reactive({})/observe({})
# 例如：
# print要放到observe({})里才能正常执行

# !!!!! reactive({}) !!!!!!

# 如果要自己定义反应变量，一定要放到reactive({})中
# 例如：
# priceDiff <- reactive({
#   diff(input$priceInput)
# })

# 而且不能直接访问priceDiff,必须要加(),即priceDiff(),此时将它当成了一个函数！


#---- 42.10.2 Using reactive variables to reduce code duplication ----

# filtered <- reactive({
#   bcl %>%
#     filter(Price >= input$priceInput[1],
#            Price <= input$priceInput[2],
#            Type == input$typeInput,
#            Country == input$countryInput
#     )
# })

#------ 42.11 Using uiOutput() to create UI elements dynamically ------
# 使用uiOutput()动态创建UI元素

# library(shiny)
# ui <- fluidPage(
#   numericInput("num", "Maximum slider value", 5),
#   uiOutput("slider")
# )
# 
# server <- function(input, output) {
#   output$slider <- renderUI({
#     sliderInput("slider", "Slider", min = 0,
#                 max = input$num, value = 0)
#   })
# }
# 
# shinyApp(ui = ui, server = server)

#---- 42.11.2 Use uiOutput() in our app to populate the countries ----


#---- 42.11.3 Errors showing up and quickly disappearing ----
# 第一次访问国家时候,并没有这个input!!多以会发生短暂的错误
# 修正：
# if (is.null(input$countryInput)) {
#   return(NULL)
# }  
# if (is.null(filtered())) {
#   return()
# }

#---- 42.12 Final Shiny app code ----
# 最终代码
# library(shiny)
# library(ggplot2)
# library(dplyr)
# 
# bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
# 
# ui <- fluidPage(
#   titlePanel("BC Liquor Store prices"),
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
#       radioButtons("typeInput", "Product type",
#                    choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
#                    selected = "WINE"),
#       uiOutput("countryOutput")
#     ),
#     mainPanel(
#       plotOutput("coolplot"),
#       br(), br(),
#       tableOutput("results")
#     )
#   )
# )
# 
# server <- function(input, output) {
#   output$countryOutput <- renderUI({
#     selectInput("countryInput", "Country",
#                 sort(unique(bcl$Country)),
#                 selected = "CANADA")
#   })  
#   
#   filtered <- reactive({
#     if (is.null(input$countryInput)) {
#       return(NULL)
#     }    
#     
#     bcl %>%
#       filter(Price >= input$priceInput[1],
#              Price <= input$priceInput[2],
#              Type == input$typeInput,
#              Country == input$countryInput
#       )
#   })
#   
#   output$coolplot <- renderPlot({
#     if (is.null(filtered())) {
#       return()
#     }
#     ggplot(filtered(), aes(Alcohol_Content)) +
#       geom_histogram()
#   })
#   
#   output$results <- renderTable({
#     filtered()
#   })
# }
# 
# shinyApp(ui = ui, server = server)

# 

#------ 42.13 Share your app with the world ------

#---- 42.13.1 Host on shinyapps.io ----

#---- 42.13.2 Host on a Shiny Server ----

#------42.14 More Shiny features to check out------

#---- 42.14.1 Shiny in R Markdown ----
# ---
#   output: html_document
# runtime: shiny
# ---
#   
#   ```{r echo=FALSE}
# sliderInput("num", "Choose a number",
#             0, 100, 20)
# 
# renderPlot({
#   plot(seq(input$num))
# })
# ```


#---- 42.14.2 Use conditionalPanel() to conditionally show UI elements----

# library(shiny)
# ui <- fluidPage(
#   numericInput("num", "Number", 5, 1, 10),
#   conditionalPanel(
#     "input.num >=5",
#     "Hello!"
#   )
# )
# server <- function(input, output) {}
# shinyApp(ui = ui, server = server)
# 

# ---- 42.14.3 Use navbarPage() or tabsetPanel() to have multiple tabs in the UI ----
# library(shiny)
# ui <- fluidPage(
#   tabsetPanel(
#     tabPanel("Tab 1", "Hello"),
#     tabPanel("Tab 2", "there!")
#   )
# )
# server <- function(input, output) {}
# shinyApp(ui = ui, server = server)

#---- 42.14.4 Use DT for beautiful, interactive tables ----


#---- 42.14.5 Use isolate() function to remove a dependency on a reactive variable ----


#---- 42.14.6 Use update*Input() functions to update input values programmatically----

# library(shiny)
# ui <- fluidPage(
#   sliderInput("slider", "Move me", value = 5, 1, 10),
#   numericInput("num", "Number", value = 5, 1, 10)
# )
# server <- function(input, output, session) {
#   observe({
#     updateNumericInput(session, "num", value = input$slider)
#   })
# }
# shinyApp(ui = ui, server = server)

#---- 42.14.8 Use global.R to define objects available to both ui.R and server.R ----

#---- 42.14.9 Add images----
# You can add an image to your Shiny app by placing an image under the 
# www/ folder and using the UI function img(src = "image.png"). 

#---- 42.14.10 Add JavaScript/CSS ----
# library(shiny)
# ui <- fluidPage(
#   tags$head(tags$script("alert('Hello!');")),
#   tags$head(tags$style("body{ color: blue; }")),
#   "Hello"
# )
# server <- function(input, output) {
#   
# }
# shinyApp(ui = ui, server = server)

#------ 42.15 Ideas to improve our app ------
# 1.将应用程序拆分为两个单独的文件：ui.R和server.R。
# 提示：分配给ui变量的ui.R所有代码server都进入了该函数的所有代码中server.R。
#       您无需显式调用该shinyApp()函数。

# 2.添加一个选项以按价格对结果表进行排序。
# 提示：用于从用户checkboxInput()获取TRUE/ FALSE值。

# 3.将BC白酒商店的图像添加到UI。
# 提示：将图像放置在名为的文件夹中www，并用于img(src = "imagename.png")添加图像。

# 4.部署到Shinyapps.io，与互联网上的所有人共享您的应用程序。
# 提示：转到shinyapps.io，注册一个帐户，然后单击RStudio中的“发布应用程序”按钮。

# 5.使用DT包将当前结果表转换为交互式表。
# 提示：安装DT软件包，替换为tableOutput()，DT::dataTableOutput()
# 然后替换renderTable()为DT::renderDataTable()。

# 6.向图中添加参数。
# 提示：您将需要添加将用作绘图参数的输入函数。您可以shinyjs::colourInput()
# 用来让用户决定绘图中条形的颜色。

# 7.当用户选择返回0个结果的过滤器时，该应用当前行为异常。
# 例如，尝试搜索比利时的葡萄酒。R控制台中将生成一个空图和一个空表，
# 并且将出现警告消息。尝试找出出现此警告消息的原因以及解决方法。
# 提示：发生问题是因为renderPlot()并且renderTable()正在尝试渲染一个空的数据框。
# 要解决此问题，filtered反应式表达式应检查过滤后的数据中的行数，如果该数为0，
# 则返回NULL而不是0行数据帧。

# 8.将图表和表格放在单独的选项卡中。
# 提示：使用tabsetPanel()创建具有多个选项卡的接口。

# 9.如果您知道CSS，请添加CSS以使您的应用看起来更好。
# 提示：在下面添加一个CSS文件，www并使用该函数includeCSS()在您的应用中使用它。

# 10.实验与添加额外的功能，以闪亮的包，比如shinyjs，leaflet，shinydashboard，
# shinythemes，ggvis。
# 提示：每个程序包都是唯一的，并且具有不同的用途，
# 因此您需要阅读每个程序包的文档才能知道它提供了什么以及如何使用它。

# 11.显示每当过滤器更改时发现的结果数。例如，当搜索价格在$ 20- $ 40的意大利
# 葡萄酒时，应用程序将显示文本“我们为您找到122个选项”。
# 提示：textOutput()在UI中添加一个，并在其相应的位置renderText()
# 使用该filtered()对象中的行数。

# 12.允许用户将结果表下载为.csv文件。
# 提示：查看downloadButton()和downloadHandler()功能。

# 13.当用户只想看葡萄酒时，请显示一个新输入，允许用户按甜度等级进行过滤。
# 如果选择了葡萄酒，则仅显示此输入。
# 提示：为甜度级别创建一个新的输入函数，并将其用于过滤数据的服务器代码中。
# 使用conditionalPanel()有条件地显示这个新的输入。
# 的condition论点conditionalPanel应该像input.typeInput == "WINE"。

# 14.允许用户同时搜索多种酒精类型，而不是只能选择葡萄酒/啤酒/等。
# 提示：有两种方法可以做到这一点。由于复选框支持选择多个项目，
# 因此可以将typeInput单选按钮更改为复选框（checkboxGroupInput()），
# 也可以将其参数更改typeInput为选择框（selectInput()）multiple = TRUE以
# 支持选择多个选项。

# 15.如果查看数据集，您会看到每种产品都有一个“类型”
# （啤酒，葡萄酒，烈性酒或茶点）和一个“子类型”（红酒，朗姆酒，苹果酒等）。
# 为“子类型”添加一个输入，该输入将允许用户仅过滤产品的特定子类型。
# 由于每种类型都有不同的子类型选项，因此每次选择新类型时，
# 都应重新生成子类型的选择。例如，如果选择“葡萄酒”，
# 则可用的子类型应该是白葡萄酒，红葡萄酒等。
# 提示：用于uiOutput()在服务器代码中创建此输入。

# 16.为用户提供一种显示来自所有国家/地区的结果的方法
# （而不是仅由一个特定国家/地区强制进行过滤）。
# 提示：有两种方法可以解决此问题。您可以在国家/地区选项的下拉列表中
# 添加“全部”值，可以包含“按国家/地区过滤”复选框，仅显示下拉列表。