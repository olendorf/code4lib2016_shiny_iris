
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output, session) {
  capitalize <- function(str){ 
    paste(
      toupper(substring(str, 1, 1)), 
      substring(str, 2), sep="")
  }
  
  subset.iris <- function(species) {
    subset(iris, Species == species)
  }
  
  
  
  tabPanel.plotOutput <- function(name) {
    tabPanel(name, plotOutput(name))
  }
  
  
   output[["All"]] <- renderPlot(
     hist(iris$Sepal.Length, main = "All Species")
   )
   
   species <- levels(iris$Species)
   
   for(index in 1:length(species))
   {
     local({
       tab.name <- capitalize(species[index])
       subset.data <- subset(iris, Species == species[index])
       output[[tab.name]] <- renderPlot({
         hist(subset.data$Sepal.Length, main = tab.name)
       })
     })
     
   }
  

  output$irisTabs <- renderUI({
    tabs <- lapply(tabs, tabPanel.plotOutput)
    do.call(tabsetPanel, tabs)
  })
})
