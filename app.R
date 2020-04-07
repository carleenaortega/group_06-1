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

#relevel and recode factors
adult_data$race <- fct_infreq(adult_data$race)  #sort by most frequent
adult_data$race <-fct_recode(adult_data$race, "Asian/Pacific Islander" = "Asian-Pac-Islander", 
                             "Native America/Inuit" = "Amer-Indian-Eskimo")

adult_data$marital_status <- fct_relevel(adult_data$marital_status,  "Never-married", 
                                         "Married-civ-spouse", "Married-AF-spouse", 
                                         "Married-spouse-absent", "Divorced" , "Separated", "Widowed")
adult_data$marital_status <-fct_recode(adult_data$marital_status, "Married: Armed Forces Spouse" = "Married-AF-spouse",
                                       "Married: Spouse Absent" = "Married-spouse-absent", "Never Married" = "Never-married", 
                                       "Married: Civilian Spouse" = "Married-civ-spouse")

adult_data$education <- fct_relevel(adult_data$education, "Preschool", "1st-4th",  
                                    "5th-6th" , "7th-8th", "9th", "10th", "11th", 
                                    "12th", "HS-grad","Prof-school","Assoc-acdm",
                                    "Assoc-voc","Some-college","Bachelors","Masters","Doctorate")
adult_data$education <- fct_recode(adult_data$education,"High School Grad" = "HS-grad",
                                   "Associate ACDM" = "Assoc-acdm", "Associate VOC"="Assoc-voc","Some College"="Some-college")




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
      labs(title=paste0(variable, " vs. Hours Worked per Week "), x=variable, y="Hours Worked per Week") +
      theme(axis.text.x = element_text(angle=45, hjust =1))
    
  } else {
    
    boxplot <- adult_data %>%
      ggplot(aes(sex, hours_per_week)) +
      geom_boxplot(outlier.size=0.05) +
      facet_wrap(formula(paste("~", var))) +
      theme_bw(15) + 
      labs(title=paste0(variable, " vs. Hours Worked per Week "), x=variable, y="Hours Worked per Week") +
      theme(axis.text.x = element_text(angle=45, hjust =1))
    
  }
  
  ggplotly(boxplot) #if time permits, arrange the education, merge the status to single, married, divorce, widowed, color code male and female
  
}


##Make age plot
make_age <- function(age_value=list("2","7"), sex_value='no'){
  
  #Get labels
  age_var_1 <- as.numeric(AgeKey$label[AgeKey$value==age_value[1]])
  age_var_2 <- as.numeric(AgeKey$label[AgeKey$value==age_value[2]])
  sex_var = SexKey$label[SexKey$value==sex_value]
  
  #if sex = no, make normal boxplot. Else, make side-by-side male and female boxplotage
  
  if (sex_var=="No") {
    
    age_data <- adult_data %>% group_by(age) %>% summarize(mean=mean(hours_per_week))
    ageplot <-  age_data  %>%   filter(age > age_var_1 & age < age_var_2 ) %>% 
      ggplot(aes(age, mean)) +
      geom_line() +
      theme_bw(15) +
      labs(title=paste0("Age vs. Hours Worked per Week (from ", age_var_1, " to ", age_var_2," years old)"), x="Age (Years)", y="Hours Worked per Week")
    
    
  } else {
    
    age_data <- adult_data %>% group_by(age, sex) %>% summarize(mean=mean(hours_per_week))
    ageplot <-  age_data  %>%   filter(age > age_var_1 & age < age_var_2 ) %>% 
      ggplot(aes(age, mean, color=sex)) +
      geom_line() +
      theme_bw(15) +
      labs(title=paste0("Age vs. Hours Worked per Week (from ", age_var_1, " to ", age_var_2," years old)"), x="Age (Years)", y="Hours Worked per Week")
    
  }
  
  ggplotly(ageplot)
  
}

##Assign components of dashboard to variables---------------------

#slider
slider <- dccRangeSlider(
  id = "Age Slider",
  min = 0,
  max = 8,
  value=list("2","7"),  #These become value[1] and and value[2]
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

context <- dccMarkdown("This dashboard explores the [Adult Income data set](http://archive.ics.uci.edu/ml/datasets/Adult) to observe the relationship of several factors such as age, sex, educational level with an individuals number of weekly work hours")

varddown<- htmlLabel("Please select a variable to explore:")

sexopt<- htmlLabel("Would you like to factor in the sex of individuals?")

ageslider <- htmlLabel("What ages do you wish to explore?")

space<-htmlIframe(height=50, width=1, style=list(borderWidth = 0))


#elements
div_tabs<-htmlDiv(
  list(
    dccTabs(id='tabs', value='tab-1', children=list(
      dccTab(label='Race, Education and Marital Status', value='tab-1'),
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
app$run_server(host = "0.0.0.0", ports = Sys.getenv('PORT', 8050)) #Need for deployment
