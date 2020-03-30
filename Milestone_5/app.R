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

##Read Data-----------------------------------------------------
adult_data <- read.csv("data/adult_data_clean.csv")



##make Key tibbles with labels and values----------------------
variableKey <- tibble(label=c("Age","Work Class", "Eduction","Marital Status","Occupation","Relationship","Income","Race","Country"),
                      value=c("age","workclass", "education","marital_status","occupation","relationship","income", "race","country"))  #values are actual column names 

AgeKey <- tibble(label=c("<20","30", "40", "50","60","70","80","90","100"), #These will be cumuluative ages markes on slider
                 value=c("20","30", "40", "50","60","70","80","90","100"))  #will filter data set based on age < value

SexKey <- tibble(label=c("Yes", "No"),
                 value=c("yes","no"))



##Functions--------------------------------------------------

##Make boxplot
make_boxplot<- function(variable, age, sex)  {
  
  #Get labels
  variable <- variableKey$label[variableKey$value==variable]
  age_var <- AgeKey$label[AgeKey$value==age]
  
  #if sex = no, make normal boxplot. Else, make side-by-side male and female boxplot
  if (!!sym(sex) == "no") {
    
    boxplot <- adult_data %>% filter(age < !!sym(age_var)) %>%
      ggplot(aes(!!sym(variable), hours_per_week)) +
      geom_boxplot() +
      theme_bw() +
      labs(title=paste0(variable, "vs. hours worked per week", x=variable, y="Hours per week"))
    
  } else {
    
    boxplot <- adult_data %>% filter(age < !!sym(age_var)) %>%
      ggplot(aes(sex, hours_per_week)) +
      geom_boxplot() +
      facet_wrap(~!!sym(variable)) +
      theme_bw() +
      labs(title=paste0(variable, "vs. hours worked per week", x=variable, y="Hours per week"))
    
  }
  
  #if variable = age, don't show plot (line plot will show instead)
  if (variable == "Age") {    
    return(NULL)  
  } else {
    ggplotly(boxplot)
  }
  
  
}

##Make Density plot
make_violin <- function(variable, age, sex)  {
  
  #Get labels
  variable <- variableKey$label[variableKey$value==variable]
  age <- AgeKey$label[AgeKey$value==age]
  
  ##TODO: Make if else statment for graphs:
  #if sex = no, make normal violin plot. Else, make side-by-side male and female violin plots.
  if (!!sym(sex) == "no") {
    
    boxplot <- adult_data %>% filter(age < !!sym(age_var)) %>%
      ggplot(aes(!!sym(variable), hours_per_week)) +
      geom_violin() +
      theme_bw() +
      labs(title=paste0(variable, "vs. hours worked per week", x=variable, y="Hours per week"))
    
  } else {
    
    boxplot <- adult_data %>% filter(age < !!sym(age_var)) %>%
      ggplot(aes(sex, hours_per_week)) +
      geom_violin() +
      facet_wrap(~!!sym(variable)) +
      theme_bw() +
      labs(title=paste0(variable, "vs. hours worked per week", x=variable, y="Hours per week"))
    
  }
  
  
  #if variable = age, don't show plot (line plot will show instead)
  if (variable == "Age") {
    return(NULL)  
  } else {
    ggplotly(violin)
  }
  
  
}


#Make line plot for Age
make_line <- function(variable, age, sex)  {
  
  #Get labels
  variable <- variableKey$label[variableKey$value==variable]
  age <- AgeKey$label[AgeKey$value==age]
  
  #if sex = no, make single line graph. Else, two lines for male and female.
  ##THIS plot isn't what I was thinking of but don't know how to make other one
  if (!!sym(sex) == "no") {
    line <-  adult_data %>% filter(age < 50) %>% 
      ggplot(aes(age, hours_per_week)) +
      geom_point(alpha=0.05, color='lightskyblue') + 
      geom_smooth(method='lm',color='red') +
      theme_bw()
    
  } else {
    #Make plot with two lines
    
    
  }
  
  
  #if variable = age, DO show plot:  (other two won't be shown)
  if (variable == "Age") {
    ggplotly(line)
  } 
  
  
}





##Assign components of dashboard to variables---------------------

#slider
slider <- dccSlider(
  id = "Age Slider",
  min = 0,
  max = 9,
  value= ,
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
  value='education' #default value 
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


violin_graph <-dccGraph(
  id = 'Violin',
  figure=make_violin()  
) 


Line_graph <- dccGraph(
  id='Line',
  figure=make_line()
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
      subtitle
      
    )
  )
)



##Callbacks------------------------------

#Boxplot
app$callback( 
  output=list(id='Boxplot', property='figure'),  #id and property of id to update (dccGraph)
  #based on:
  params=list(input(id='Variable Dropdown', property='value'),
              input(id = 'Age Slider', property='value'),
              input(id='Sex Button', property='value')), 
  #translate params into function arguments
  function(variable, age, sex) {
    make_boxplot(variable, age, sex)
  }
)

#Violin plot
app$callback( 
  output=list(id= 'Violin', property='figure'),
  params=list(input(id='Variable Dropdown', property='value'),
              input(id = 'Age Slider', property='value'),
              input(id='Sex Button', property='value')), 
  function(variable, age, sex) {
    make_violin(variable, age, sex)
  }
  
)

#Line Plot for Age
app$callback( 
  output=list(id= 'Line', property='figure'),
  params=list(input(id='Variable Dropdown', property='value'),
              input(id = 'Age Slider', property='value'),
              input(id='Sex Button', property='value')), 
  function(variable, age, sex) {
    make_line(variable, age, sex)
  }
  
)





##Run the app-------------------------
app$run_server(debug=TRUE)

app$run_server()
