"This is a script to do exploratory data analysis on /data/adult_data_clean.csv and to save images to /images

Usage: analysis_data.R --path=<path_to_save>" -> doc

library(tidyverse)
library(ggplot2)
library(docopt)
library(glue)
library(purrr)

opt <- docopt(doc)

main <- function(analysis) {
  #read the file
  data <- read.csv("data/adult_data_clean.csv",row.names=1)
  
  # 1. Is earning more than 50K correlated with the education level, marital status, and hours worked per week? 
  earnings<-data %>%
    
    
  
    print(glue("Data analysis for research questions is completed", path))
}

main(opt$path)