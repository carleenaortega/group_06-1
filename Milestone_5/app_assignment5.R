# author: YOUR NAME
# date: 2020-03-15

"This script is the main file that creates a Dash app for assignment 5
Usage: app.R
"

#load libraries
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(ggplot2)
library(glue)



##make Key tibbles with labels and values----------------------
xKey <- tibble(label=c("Carat", "Price", "Cut", "Colour", "Clarity", "Depth Percentage", 
                       "Table", "Length", "Width", "Depth"),
               value=c("carat","price","cut","color","clarity","depth",
                       "table","x","y","z"))  #values are actual column names 

cutKey <- tibble(label=c("Fair", "Good","Very Good","Ideal","Premium"),
                 value=c("Fair", "Good","Very Good","Ideal","Premium"))  #values are real names in cut column
##Functions-----------------------------------

#Make histogram
make_histogram <- function(xaxis='carat', scale='linear') {  #set default value to Carat
  
  #get xAxis label
  xLabel <-xKey$label[xKey$value==xaxis]
  
  #set stat="count" in histogram for factors (cut, color & clarity)
  stat <- ifelse(is.factor(diamonds[[xaxis]]), "count", "bin")
  
  #Make histogram plot based on xLabel
  histogram <- diamonds %>% 
    ggplot(aes(!!sym(xaxis))) +   #COULD make another function option here for tooltip
    geom_histogram(color="black", fill="lightskyblue", alpha=0.7, stat=stat) +
    theme_bw() +
    labs(title=paste0("Number of diamonds vs. ", xLabel),
         subtitle = paste0("Scale = ", scale),
         x=xLabel, y="Number of Diamonds") 
  
  if (scale == 'log10') {
    histogram <- histogram + scale_y_continuous(trans=scale)
  }
  
  ggplotly(histogram)  #this is returned by function
  
}

##Make Scatter Plot 1
make_scatter_plot1 <- function(cut_opt ="Good") {
  
  #Get cut label
  cut <- cutKey$label[cutKey$value==cut_opt]
  
  #Make Plot
  scatter1 <- diamonds %>% filter(cut==cut) %>%    #before had filter(cut==!!sym(cut)), which is why it wasn't working
    sample_n(size=1000) %>%
    ggplot(aes(price, carat, color=color)) +
    geom_point(alpha=0.5) +
    theme_bw() +
    labs(x="Price", y="Carat",title=paste0("Price vs. quality of diamonds with ", cut, "cut")) 
  
  
  ggplotly(scatter1)
  
}


##Make Scatter Plot 2
make_scatter_plot2 <- function(cut_opt ="Good")  {
  
  #Get cut label
  cut <- cutKey$label[cutKey$value==cut_opt]
  
  scatter2 <-diamonds %>% filter(cut==cut) %>%
    sample_n(size=1000) %>%
    ggplot(aes(depth, table, color=clarity)) +
    geom_point(alpha=0.4) +
    theme_bw() +
    labs(title=paste0("Depth vs. table of diamonds with ", cut, "cut"), y="Table", x="Depth")
  
  ggplotly(scatter2)
  
}



##Assign components of dashboard to variables------------------

#slider
slider <- dccSlider(
  id = "Cut Slider",
  min = 0,
  max = 4,
  marks=map(
    1:nrow(cutKey), function(i) { 
      list(label=cutKey$label[i], value=cutKey$value[i])  
    })
)

#dropdown
hist_dropdown <-dccDropdown(
  id = 'hist_dropdown',
  options=map(
    1:nrow(xKey), function(i) { 
      list(label=xKey$label[i], value=xKey$value[i])  
    }),
  value='carat'  
)

#Button
button <-  dccRadioItems(
  id = 'yaxis_scale',
  options = list(list(label = 'Linear', value='linear'), 
                 list(label='Log 10', value='log10')),
  value='linear')


#Graphs
hist_graph <-dccGraph(
  id = 'hist_graph',
  figure=make_histogram()  
) 

scatter_plot1 <- dccGraph(
  id = 'Scatter plot1',
  figure=make_scatter_plot1()
)

scatter_plot2 <- dccGraph(
  id = 'Scatter plot2',
  figure=make_scatter_plot2()
)



#Titles 
heading <- htmlH1("Diamonds Dashboard")
subtitle <- htmlH3("Exploring the R diamonds dataset")
explain_dropdown <- htmlP("Select an option from the menu:")
explain_button <- htmlP("Choose a scale:")
explain_slider <- htmlP("Choose a cut:")

#Sources
sources <- dccMarkdown("[Data Source](https://cran.r-project.org/web/packages/diamonds/README.html)")


#create dash instance

app <- Dash$new()

##Dash layout---------------

app$layout(
  htmlDiv(
    list(
      heading,
      subtitle,
      htmlLabel("Diamonds Sold"),
      explain_dropdown,
      hist_dropdown,
      explain_button,
      button,
      htmlP(""),
      hist_graph, 
      htmlP(" "),
      explain_slider,
      slider,
      htmlLabel("Scatter Plot 1"),
      scatter_plot1,
      htmlP("  "),
      htmlLabel("Scatter Plot 2"),
      scatter_plot2,
      htmlLabel("Sources"),
      sources
      
    )
  )
)



##Callbacks----------------

#Histogram
app$callback( 
  output=list(id='hist_graph', property='figure'),  #id and property of id to update (dccGraph)
  #based on:
  params=list(input(id='hist_dropdown', property='value'),
              input(id = 'yaxis_scale', property='value')), 
  #translate params into function arguments
  function(xaxis,scale) {
    make_histogram(xaxis, scale)
  }
)

#Scatter plot 1
app$callback( 
  output=list(id= 'Scatter plot1', property='figure'),
  params=list(input(id='Cut Slider', property='value')),
  function(cut_opt) {
    make_scatter_plot1(cut_opt)
  }
  
)


#Scatter plot 2
app$callback( 
  output=list(id ='Scatter plot2', property='figure'),
  params=list(input(id='Cut Slider', property='value')),
  function(cut_opt) {
    make_scatter_plot2(cut_opt)
  }
  
)


##Run the app-------------------------
app$run_server()
