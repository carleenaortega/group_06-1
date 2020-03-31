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

##Read Data-----------------------------------------------------
adult_data <- read.csv("data/adult_data_clean.csv")


##make Key tibbles with labels and values----------------------
variableKey <- tibble(label=c("Age","Work Class", "Eduction","Marital Status","Occupation","Relationship","Income","Race","Country"),
                      value=c("age","workclass", "education","marital_status","occupation","relationship","income", "race","country"))  #values are actual column names 

AgeKey <- tibble(label=c("20","30", "40", "50","60","70","80","90","100"), #These will be cumuluative ages markes on slider
                 value=c("20","30", "40", "50","60","70","80","90","100"))  #will filter data set based on age < value

SexKey <- tibble(label=c("Yes", "No"),
                 value=c("yes","no"))



##Functions--------------------------------------------------

##Make boxplot
make_boxplot <- function(var ='workclass', age_value='90', sex_value='no')  {
  
  #Get labels
  variable <- variableKey$label[variableKey$value==var]
  age_var <- AgeKey$label[AgeKey$value==age_value]
  sex_var = SexKey$label[SexKey$value==sex_value]
  
  #if sex = no, make normal boxplot. Else, make side-by-side male and female boxplotage
  
  if (sex_var=="No") {
    
    boxplot <- adult_data %>% filter(age < 80) %>%  ##THIS part isn't working for age but it should?
      ggplot(aes(!!sym(var), hours_per_week)) +
      geom_boxplot(outlier.size=0.05) +
      theme_bw() +
      labs(title=paste0(variable, " vs. hours worked per week "), x=variable, y="Hours per week")
    
  } else {
    
    boxplot <- adult_data %>% filter(age < 80) %>%  ##THIS part isn't working for age but it should?
      ggplot(aes(sex, hours_per_week)) +
     geom_boxplot(outlier.size=0.05) +
     facet_wrap(formula(paste( "~", var))) +
      theme_bw() +
      labs(title=paste0(variable, " vs. hours worked per week "), x=variable, y="Hours per week")
    
  }
    
    ggplotly(boxplot)
    
}




##Assign components of dashboard to variables---------------------

#slider
slider <- dccSlider(
  id = "Age Slider",
  min = 0,
  max = 9,
  marks=map(
    1:nrow(AgeKey), function(i) { 
      list(label=AgeKey$label[i], value=AgeKey$value[i])  
    })
)


#dropdown
dropdown <-dccDropdown(
  id = 'Variable Dropdown',
  options=map(
    1:nrow(variableKey), function(i) { 
      list(label=variableKey$label[i], value=variableKey$value[i])  
    }),
  value='workclass' #default value 
)

#Button
button <-  dccRadioItems(
  id = 'Sex Button',
  options = map(
    1:nrow(SexKey), function(i) { 
      list(label=SexKey$label[i], value=SexKey$value[i])  
    }),
  value='no')


#Graphs
boxplot_graph <-dccGraph(
  id = 'Boxplot',
  figure=make_boxplot()  
) 



#Headings etc
heading <- htmlH1("STAT547 Dashboard")
subtitle <- htmlH3("Carleena Ortega and Saelin Bjornson")


#create dash instance

app <- Dash$new()

##Dash layout----------------------------------

app$layout(
  htmlDiv(
    list(
      heading,
      subtitle, 
      dropdown,
      button,
      slider,
      boxplot_graph
    )
  )
)



##Callbacks------------------------------

#Boxplot
app$callback( 
  output=list(id='Boxplot', property='figure'), 
  params=list(input(id='Variable Dropdown', property='value'),
  input(id='Age Slider', property='value'),
  input(id='Sex Button', property='value')),
  function(var, age_value, sex_value) {
    make_boxplot(var, age_value, sex_value)
  }
)



##Run the app-------------------------

app$run_server()
