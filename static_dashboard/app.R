#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(shinydashboard)
library(dplyr)
library(DT)
library(ggplot2)
library(plotly)

###############
# Load bee data
###############

bee <- read_csv("vHoneyNeonic_v03.csv")

# Define factor columns
bee$Region <- as.factor(bee$Region)
bee$state <- as.factor(bee$state)


#############
# Define UI #
#############

ui <- dashboardPage(
  
  # Set title
  dashboardHeader(
    title = "US Honey Production, 1991-2017",
    titleWidth=350
  ),
  
  # Define sidebar
  dashboardSidebar(
    
    # Set tab titles
    sidebarMenu(
      menuItem("Yield per Colony", tabName="ypc"),
      menuItem("Price per Pound", tabName="ppp"),
      menuItem("Total Produced", tabName="total")
    )
  ),
  
  # Define body
  dashboardBody(
    tabItems(
      
      # Yield per colony tab content
      tabItem(tabName="ypc"),
      
      # Price per pound tab content
      tabItem(tabName="ppp"),
      
      # Total produced
      tabItem(tabName="total")
    )
  )
)


#################
# Define server #
#################

server <- function(input, output) {
  
  # # Reactive data function
  # bee.input <- reactive({
  #   req(input$region)  # Require non-null region selection
  #   filter(bee,
  #     Region %in% input$region &
  #     numcol >= input$year[1] &
  #     year <= input$year[2]
  #   )
  # })
}


#######################
# Run the application #
#######################

shinyApp(ui = ui, server = server)
