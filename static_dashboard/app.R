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
bee$year <- as.factor(bee$year)


#############
# Define UI #
#############

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)


#################
# Define server #
#################

server <- function(input, output) { }


#######################
# Run the application #
#######################

shinyApp(ui = ui, server = server)
