# Programming Exercise 2
# Haoheng Zhu(30376467)

require(ggplot2)
require(dplyr)
require(shiny)
require(leaflet)

# Question 1 ---- read dataset
# read data
rawData <- read.csv('assignment-02-data-formated.csv')

# explore data
head(rawData)

# check data structure
str(rawData)

# Question 2 ---- Plot data
# value column is factor datatype, needs to change to numeric type
rawData$value <- as.numeric(as.character(sub('%', '', rawData$value)))

# in order to sort by latitude, need to change location to factor type
# inspired by https://stackoverflow.com/questions/14262497/fixing-the-order-of-facets-in-ggplot
# arrange dataframe before changing factor type
rawData <- arrange(rawData, desc(rawData$latitude))
rawData$location <- factor(rawData$location, levels = unique(rawData$location), ordered = T)

# check structure after datatype changes
str(rawData)

# make and save first plot
plot1 <- ggplot(rawData, aes(year, value)) %>%
+ geom_point() %>%
+ facet_grid(location~coralType)

# check first plot
plot1

# smoothing data
plot2 <- plot1 + geom_smooth(
  aes(group = 1),
  method = 'lm',
  color = 'blue',
  formula = y~poly(x,2),
  se = TRUE
)

# plot second graph
plot2



# Question 3 ----- Shiny

ui <- fluidPage(
  # app title
  titlePanel("Shiny Visulization"),
  
  #input and output definitions
  sidebarLayout(
    
    # sidebar panel for inputs
    sidebarPanel(
      
      # select type of coral as input:
      selectInput(inputId = "CoralType", label = strong('Coral Type'),
                  choices = unique(rawData$coralType),
                  selected = 'blue coral'),
      
      
      # select type of smoother from c('lm', 'glm', 'loess')
      selectInput(inputId = 'smoother', label = strong('Smoother Type'),
                  choices = c('lm', 'glm', 'loess'),
                  selected = 'lm'),
      
      # select color of the smoother
      selectInput(inputId = 'color', label = strong('Smoother Color'),
                  choices = c('black', 'red', 'blue'),
                  selected = 'blue')
      
      
    ),
    mainPanel(
      plotOutput(outputId = "scatterplot", height = '600px', width = '1000px',leafletOutput("locationMap"))
    )
  )
)

# server
server <- function(input, output) {
  # subset data
  output$scatterplot <- renderPlot({
    ggplot(subset(rawData, coralType == input$CoralType), aes(year, value)) %>%
      + geom_point() %>%
      + facet_grid(coralType ~ location) %>%
      + geom_smooth(
        aes(group = 1),
        method = input$smoother,
        color = input$color,
        se = TRUE
      )
    
  })
}

# shiny app
shinyApp(ui = ui, server = server)

# question 4 ---- leaflet
leaflet(data = rawData) %>%
  addTiles() %>%
  addMarkers(~longitude, ~latitude, popup = ~location)

# question 5 ---- shiny and leaflet

ui <- fluidPage(
 
  checkboxGroupInput(inputId = 'Location', 
               label = strong('Choose Location'),
               choices = unique(rawData$location)
               ),
  mainPanel(leafletOutput("locationMap"))
)

server <- function(input, output){
  
  output$locationMap <- renderLeaflet({
    leaflet(subset(rawData, location == input$Location)) %>%
      addTiles() %>%
      addMarkers(~longitude, ~latitude, popup = ~location)

  })
}

shinyApp(ui, server)