
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output, session) {
  
  # Capitalizes the first letter in a string.
  capitalize <- function(str){ 
    paste(
      toupper(substring(str, 1, 1)), 
      substring(str, 2), sep="")
  }
  
  # Helper to make it a little easier to use lapply/
  tabPanel.plotOutput <- function(name) {
    tabPanel(name, plotOutput(name))
  }
  
  
  # Make the "All" tab since its not in the data
  output[["All"]] <- renderPlot(
   hist(iris$Sepal.Length, main = "All Species")
  )
  
  # Get our list of the species. 
  species <- levels(iris$Species)
  
  # For each species add the data.
  for(index in 1:length(species))
  {
   # If we don't add this local method, R just uses the lat
   # tab for all the plots. 
   local({
     tab.name <- capitalize(species[index])
     subset.data <- subset(iris, Species == species[index])
     output[[tab.name]] <- renderPlot({
       hist(subset.data$Sepal.Length, main = tab.name)
     })
   })
   
   }
  

  # Creates the tabs.
  output$irisTabs <- renderUI({
    tabs <- c("All", lapply(levels(iris$Species), capitalize))
    tabs <- lapply(tabs, tabPanel.plotOutput)
    do.call(tabsetPanel, tabs)
  })
})
