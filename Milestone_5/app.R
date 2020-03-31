"This script creates a Dash app for Milestone 5.
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
      theme_bw() + 
      labs(title=paste0(variable, " vs. Hours Worked per Week "), x=variable, y="Hours Worked per Week")
    
  } else {

    boxplot <- adult_data %>%
      ggplot(aes(sex, hours_per_week)) +
      geom_boxplot(outlier.size=0.05) +
      facet_wrap(formula(paste("~", var))) +
      theme_bw() + 
      labs(title=paste0(variable, " vs. Hours Worked per Week "), x=variable, y="Hours Worked per Week")

  }
  
  ggplotly(boxplot) #if time permits, arrange the 
  
}

 
##Make violin
make_age <- function(var='workclass', age_value='8', sex_value='no'){
  
  #Get labels
  variable <- variableKey$label[variableKey$value==var]
  age_var <- as.numeric(AgeKey$label[AgeKey$value==age_value])
  sex_var = SexKey$label[SexKey$value==sex_value]
  
  #if sex = no, make normal boxplot. Else, make side-by-side male and female boxplotage
  
  if (sex_var=="No") {
    
    boxplot <- adult_data %>% filter(age < age_var) %>%  ##THIS part isn't working for age but it should?
      ggplot(aes(!!sym(var), hours_per_week)) +
      geom_violin(outlier.size=0.05) +
      theme_bw() +
    labs(title=paste0(variable, " vs. Hours Worked per Week "), x=variable, y="Hours per week")
    
  } else {
    
    boxplot <- adult_data %>% filter(age < age_var) %>%  ##THIS part isn't working for age but it should?
      ggplot(aes(sex, hours_per_week)) +
      geom_violin(outlier.size=0.05) +
      facet_wrap(formula(paste("~", var))) +
      theme_bw() +
    labs(title=paste0(variable, " vs. Hours Worked per Week "), x=variable, y="Hours Worked per Week")
    
  }
  
  ggplotly(boxplot)
  
}


##Assign components of dashboard to variables---------------------

#slider
slider <- dccSlider(
  id = "Age Slider",
  min = 0,
  max = 8,
  value="8",
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

violin_graph <-dccGraph(
  id = 'Violin',
  figure=make_violin()  
) 


#Headings and label
heading <- htmlH1("STAT547 Dashboard")

authors <- htmlH2("by Carleena Ortega and Saelin Bjornson")

context <- htmlH3("This dashboard explores the Adult Income data set to observe the relationship of several factors such as age, sex, and work class with an individuals number of weekly work hours")

varddown<- htmlLabel("Please select a variable to explore:")

sexopt<- htmlLabel("Would you like to factor in the sex of individuals?")

ageslider <- htmlLabel("What ages do you wish to explore? (minimum of 20 years old)")

space<-htmlIframe(height=50, width=1, style=list(borderWidth = 0))



#create dash instance

app <- Dash$new()

##Dash layout----------------------------------

app$layout(
  #Title bar
  htmlDiv(
    list(
      heading,
      authors,
      context,
      space
    )
  ),
    #make the tabs
  htmlDiv(
    list(
      dccTabs(id='tabs', value='tab-1', children=list(
        dccTab(label='Categorical Variables', value='tab-1'),
        dccTab(label='Age', value='tab-2')
      )),
      htmlDiv(id='tabs-content')
    )
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
                        varddown,
                        dropdown,
                        space,
                        sexopt,
                        button,
                        space,
                        space,
                        space,
                        boxplot_graph
                      )
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
                    ageslider,
                    slider,
                    space,
                    violin_graph
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

# #Violin
  
app$callback(
  output=list(id='Violin', property='figure'),
  params=list(input(id='Variable Dropdown', property='value'),
              input(id='Age Slider', property='value'),
              input(id='Sex Button', property='value')),
  function(var, age_value, sex_value) {
    make_violin(var, age_value, sex_value)
  }
)



##Run the app-------------------------

app$run_server()
