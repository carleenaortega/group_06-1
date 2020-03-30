# author: Carleena Ortega and Saelin Bjornson
# date: 2020-03-15

"This script creates a Dash app.

Usage: app.R
"

#At minimum your dashboard must have:
#clear headings, labels, instructions for use (using html and/or markdown components)
#some type of motivation for what the dashboard is supposed to do, or what questions it can help you answer
#at least two plots (using dccGraph and ggplot2 with ggplotly)
#a minimum of two core components
#a minimum of two callbacks
#an aesthetically pleasing layout (you can use the examples or make your own)

# Libraries
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(ggplot2)
library(plotly)
library(tidyverse)

app <- Dash$new()

# Create elements

h1<-htmlH1('STAT547 Group 6 Dashboard')
h2<-htmlH2('Carleena Ortega & Saelin Bjornson')
h3<-htmlH3('#insert the motivation of the app')



app$layout(
  htmlDiv(
    list(
      h1,
      h2,
      h3
    )
  )
)

app$run_server()



