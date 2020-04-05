"This script creates a Dash app for Milestone 6.
Usage: app.R
"

# Libraries
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(plotly))
suppressPackageStartupMessages(library(tidyverse))

##Read Data-----------------------------------------------------
adult_data <- read.csv("data/adult_data_clean.csv")


##make Key tibbles with labels and values----------------------
variableKey <- tibble(label=c("Marital Status","Race","Education"),
                      value=c("marital_status", "race","education"))  #values are actual column names 

AgeKey <- tibble(label=c("20","30", "40", "50","60","70","80","90","100"), #These will be cumuluative ages markes on slider
                 value=c("0","1","2","3","4","5","6","7","8"))  #will filter data set based on age < value

SexKey <- tibble(label=c("Yes", "No"),
                 value=c("yes","no"))



##Functions--------------------------------------------------

##Make boxplot
make_boxplot <- function(var='education', sex_value='no'){
  
  #Get labels
  variable <- variableKey$label[variableKey$value==var]
  sex_var = SexKey$label[SexKey$value==sex_value]
  
  #if sex = no, make normal boxplot. Else, make side-by-side male and female boxplotage
  
  if (sex_var=="No") {
    
    boxplot <- adult_data %>%
      ggplot(aes(!!sym(var), hours_per_week)) +
      geom_boxplot(outlier.size=0.05) +
      theme_bw(15) + 
      labs(title=paste0(variable, " vs. Hours Worked per Week "), x=variable, y="Hours Worked per Week")
    
  } else {
    
    boxplot <- adult_data %>%
      ggplot(aes(sex, hours_per_week)) +
      geom_boxplot(outlier.size=0.05) +
      facet_wrap(formula(paste("~", var))) +
      theme_bw(15) + 
      labs(title=paste0(variable, " vs. Hours Worked per Week "), x=variable, y="Hours Worked per Week")
    
  }
  
  ggplotly(boxplot) #if time permits, arrange the education, merge the status to single, married, divorce, widowed, color code male and female
  
}


##Make age plot
make_age <- function(age_value='8', sex_value='no'){
  
  #Get labels
  age_var <- as.numeric(AgeKey$label[AgeKey$value==age_value])
  sex_var = SexKey$label[SexKey$value==sex_value]
  
  #if sex = no, make normal boxplot. Else, make side-by-side male and female boxplotage
  
  if (sex_var=="No") {
    
    age_data <- adult_data %>% group_by(age) %>% summarize(mean=mean(hours_per_week))
    ageplot <-  age_data  %>%   filter(age < age_var) %>% 
      ggplot(aes(age, mean)) +
      geom_line() +
      theme_bw(15) +
      labs(title=paste0("Age vs. Hours Worked per Week (from 20 to ", age_var," years old)"), x="Age (Years)", y="Hours Worked per Week")
    
    
  } else {
    
    age_data <- adult_data %>% group_by(age, sex) %>% summarize(mean=mean(hours_per_week))
    ageplot <-  age_data  %>%   filter(age < age_var) %>% 
      ggplot(aes(age, mean, color=sex)) +
      geom_line() +
      theme_bw(15) +
      labs(title=paste0("Age vs. Hours Worked per Week (from 20 to ", age_var," years old)"), x="Age (Years)", y="Hours Worked per Week")
    
  }
  
  ggplotly(ageplot)
  
}

##Assign components of dashboard to variables---------------------

#slider
slider <- dccSlider(
  id = "Age Slider",
  min = 0,
  max = 8,
  value="4",
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


###Graphs
boxplot_graph <-dccGraph(
  id = 'Boxplot',
  figure=make_boxplot()  
) 

age_graph <-dccGraph(
  id = 'Age Plot',
  figure=make_age()  
) 


#Headings and label
heading <- htmlH1("STAT547 Dashboard: Exploration of the Weekly Work Hours of Individuals")

authors <- htmlH2("by Carleena Ortega and Saelin Bjornson")

context <- htmlH3("This dashboard explores the Adult Income data set to observe the relationship of several factors such as age, sex, educational level with an individuals number of weekly work hours")

varddown<- htmlLabel("Please select a variable to explore:")

sexopt<- htmlLabel("Would you like to factor in the sex of individuals?")

ageslider <- htmlLabel("What ages do you wish to explore? (minimum of 20 years old)")

space<-htmlIframe(height=50, width=1, style=list(borderWidth = 0))


#elements
div_tabs<-htmlDiv(
  list(
    dccTabs(id='tabs', value='tab-1', children=list(
      dccTab(label='Categorical Variables', value='tab-1'),
      dccTab(label='Age', value='tab-2')
    )),
    htmlDiv(id='tabs-content')
  ))

div_title<-htmlDiv(
  list(
    heading,
    authors,
    context,
    space
  ),style=list(textAlign='center', backgroundColor='#D3F1CD', margin=2, marginTop=0)
)

clarlist<-htmlDiv(
  list(varddown,
       dropdown,
       space,
       sexopt,
       button,
       space,
       space,
       space),
  style=list('width'='25%'))

#create dash instance

app <- Dash$new()

##Dash layout----------------------------------

app$layout(
  htmlDiv(
    list(div_title,
         div_tabs),
    style = list('font-size'='25px', 'width'='100%')
  )
)



##Callbacks------------------------------

#tabs callback
app$callback(
  
  output = list(id = 'tabs-content', property = 'children'),
  
  params = list(input(id='tabs', 'value')),
  
  render_content <- function(tab) {
    if (tab == 'tab-1') {
      htmlDiv(
        list(
          # DROPDOWNS
          htmlDiv(
            list(
              htmlDiv(
                list(
                  clarlist,
                  boxplot_graph
                ), style=list('columnCount'=1)
              )
              
            )
          )
        )
      )
    }
    
    else if (tab == 'tab-2') {
      htmlDiv(
        list(
          htmlDiv(
            list(
              htmlDiv(
                list(
                  sexopt,
                  button,
                  space,
                  ageslider,
                  slider,
                  space,
                  age_graph
                )
              )
            )
          )
        )
      )
    }
  }
)

#Boxplot
app$callback( 
  output=list(id='Boxplot', property='figure'), 
  params=list(input(id='Variable Dropdown', property='value'),
              input(id='Sex Button', property='value')),
  function(var, sex_value) {
    make_boxplot(var, sex_value)
  }
)

# Age Plot

app$callback(
  output=list(id='Age Plot', property='figure'),
  params=list(input(id='Age Slider', property='value'),
              input(id='Sex Button', property='value')),
  function(age_value, sex_value) {
    make_age(age_value, sex_value)
  }
)



##Run the app-------------------------

app$run_server()
