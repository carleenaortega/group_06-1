# author: Carleena Ortega and Saelin Bjornson
# date: 2020-03-15

"This script is the main file that creates a Dash app.

Usage: app.R
"

# Libraries
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(ggplot2)
library(plotly)
library(tidyverse)

app <- Dash$new()

# Load the data


app$layout(
  htmlDiv(
    list(
      
      htmlH1('Welcome')

      
    )
  )
)

app$run_server()



