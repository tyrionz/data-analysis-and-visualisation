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
      
      
      
      selectInput(inputId = 'smoother', label = strong('Smoother Type'),
                  choices = c('linear regression', 'standard error'),
                  selected = 'linear regression')
      
      
    ),
    mainPanel(
      plotOutput(outputId = "scatterplot", height = '300px')
    )
  )
)

# server
server <- function(input, output) {
  # subset data
  output$scatterplot <- reactive({
    
  })
}
