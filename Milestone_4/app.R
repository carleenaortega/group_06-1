# author: Carleena Ortega and Saelin Bjornson
# date: 2020-03-15

"This script creates a Dash app.

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


app$layout(
  htmlDiv(
    list(
      
      htmlH1('STAT547 Group 6 Dashboard'),
      htmlH3('Carleena Ortega & Saelin Bjornson')

      
    )
  )
)

app$run_server()



