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

# Read in CSV
bee <- read_csv("vHoneyNeonic_v03.csv")

# Define factor columns
bee$Region <- as.factor(bee$Region)
bee$state <- as.factor(bee$state)

# Fill NA values in pesticide columns
bee$nCLOTHIANIDIN <- bee$nCLOTHIANIDIN %>% replace_na(0)
bee$nIMIDACLOPRID <- bee$nIMIDACLOPRID %>% replace_na(0)
bee$nTHIAMETHOXAM <- bee$nTHIAMETHOXAM %>% replace_na(0)
bee$nACETAMIPRID <- bee$nACETAMIPRID %>% replace_na(0)
bee$nTHIACLOPRID <- bee$nTHIACLOPRID %>% replace_na(0)
bee$nAllNeonic <- bee$nAllNeonic %>% replace_na(0)


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
    sidebarMenu(
      
      # Set tab titles
      menuItem("Yield per Colony", tabName="ypc"),
      menuItem("Price per Pound", tabName="ppp"),
      menuItem("Total Produced", tabName="total"),
      
      br(),  # Visual spacer
      
      ## Set filter inputs ##
      # Select regions
      checkboxGroupInput(
        "reg", "Regions",
        choices = bee$Region %>%
          unique() %>% sort(),
        selected = unique(bee$Region)
      ),
      
      # Select year range
      sliderInput(
        "year","Year",
        min = min(bee$year), max = max(bee$year),
        value=c(
          min = min(bee$year), max = max(bee$year)
        ),
        sep=""  # Remove comma separator for years
      ),
      
      # Filter by range of neonic use
      sliderInput(
        "neonic", "Neonic Pesticides Used (kg)",
        min = min(bee$nAllNeonic, na.rm=T),
        max = max(bee$nAllNeonic, na.rm=T),
        value=c(
          min = min(bee$nAllNeonic, na.rm=T),
          max = max(bee$nAllNeonic, na.rm=T)
        )
      )
    )
  ),
  
  # Define body
  dashboardBody(
    tabItems(
      
      # Yield per colony tab content
      tabItem(tabName="ypc",
        
        # Average yield per colony gauge
        fluidRow(
          valueBoxOutput("mean.ypc")
        ),
        
        # Yield per colony over time plot
        fluidRow(
          box(
            title="Yield per Colony Over Time",
            plotlyOutput("ypc.plot")
          )
        )
      ),
      
      # Price per pound tab content
      tabItem(tabName="ppp",
              
        # Average price per pound gauge
        fluidRow(
          valueBoxOutput("mean.ppp")
        ),
        
        # Price per pound over time plot
        fluidRow(
          box(
            title="Price per Pound of Honey Over Time",
            plotlyOutput("ppp.plot")
          )
        )
      ),
      
      # Total produced
      tabItem(tabName="total",
              
        # Sum total honey produced gauge
        fluidRow(
          valueBoxOutput("sum.total")
        ),
        
        # Total honey produced per year plot
        fluidRow(
          box(
            title="Total Honey Produced per Year",
            plotlyOutput("total.plot")
          )
        ),
        
        # Data table
        fluidRow(
          box(
            width=12,
            title="Honey Production Data",
            DTOutput("honey.data")
          )
        )
      )
    )
  )
)


#################
# Define server #
#################

server <- function(input, output) {
  
  # Reactive data function
  bee.input <- reactive({
    
    # Require non-null region selection
    req(input$reg)
    
    # Filter according to sliders & region checks
    bee.subset <- bee %>%
      select(
        StateName, year, numcol, totalprod, yieldpercol,
        priceperlb, prodvalue, Region, nAllNeonic
      ) %>%
      filter(
        Region %in% input$reg &
        year >= input$year[1] &
        year <= input$year[2] &
        nAllNeonic >= input$neonic[1] &
        nAllNeonic <= input$neonic[2]
      )
  })
  
  ## Yield per colony tab ##
  # TODO: Reactive mean.ypc box
  
  # TODO: Reactive mean.ypc per year line plot
  
  ## Price per pound tab ##
  # TODO: Reactive mean.ppp box
  
  # TODO: Reactive mean.ppp per year line plot
  
  ## Total honey produced tab ##
  # TODO: Reactive sum.total box
  
  # TODO: Reactive total.produced per year bar plot
  
  # Data table
  output$honey.data <- renderDT({
    datatable(
      data = bee.input(),
      options = list(pageLength=10),
      rownames=F
    )
  })
}


#######################
# Run the application #
#######################

shinyApp(ui = ui, server = server)
