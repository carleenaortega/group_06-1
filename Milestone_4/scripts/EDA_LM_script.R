"This is a script to do exploratory data analysis on /data/adult_data_clean.csv and to save images to /images

Usage: EDA_LM_script.R --RDS_path=<RDS_path_to_save>" -> doc
##Exact usage from Milestone_4: Rscript scripts/EDA_LM_script.R  --RDS_path="data/"

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(docopt))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(purrr))

opt <- docopt(doc)

#' Conducts linear regression and anova on data from data/adult_data_clean.csv and saves in RDS_path
#'
#' @param RDS_path  A path to save RDS files
#' @return .rds files of linear regression models and anova tests
#' @examples 
#' function("data/")

main <- function(RDS_path) {
  #read the file
  data <- read.csv("data/adult_data_clean.csv", row.names=1)
  
  # Research question: Is hours worked per week correlated with age, relationship, education level, or sex?
  
  #Make a linear model with all variables, then test (with anova) the differences between the full model and the full model without each variable, 
  #to see if that variable has a significant effect on the response overall. 
  
  hours_full<-lm(hours_per_week~sex + education + relationship + age + race, data) 
  saveRDS(hours_full, file = glue(RDS_path,"hours_full.rds"))
  
  #testing sex
  
  hours_sex<-lm(hours_per_week~education + relationship + age + race, data) 
  saveRDS(hours_sex, file = glue(RDS_path,"hours_full_NoSex.rds"))
  
  test_sex <-anova(hours_full, hours_sex)
  saveRDS(test_sex, file=glue(RDS_path,"test_sex.rds"))
  
  #testing education
  
  hours_education<-lm(hours_per_week~sex + relationship + age + race, data) 
  saveRDS(hours_education, file = glue(RDS_path,"hours_full_NoEducation.rds"))
  
  test_education <- anova(hours_full,hours_education)
  saveRDS(test_education, file=glue(RDS_path,"test_education.rds"))
  
  #testing relationship
  
  hours_relationship<-lm(hours_per_week~sex + education + age + race, data) 
  saveRDS(hours_relationship, file = glue(RDS_path,"hours_full_NoRelationship.rds"))
  
  test_relationship <- anova(hours_full,hours_relationship)
  saveRDS(test_relationship, file=glue(RDS_path,"test_relationship.rds"))
  
  #testing age
  
  hours_age <-lm(hours_per_week~sex + education + relationship + race, data) 
  saveRDS(hours_age, file = glue(RDS_path,"hours_full_NoAge.rds"))
  
  test_age <- anova(hours_full, hours_age)
  saveRDS(test_age,file=glue(RDS_path,"test_age.rds"))
  
  #testing race
  
  hours_race <-lm(hours_per_week~sex + education + relationship + age, data) 
  saveRDS(hours_race, file = glue(RDS_path,"hours_full_NoRace.rds"))
  
  test_race <- anova(hours_full,hours_race)
  saveRDS(test_race,file=glue(RDS_path,"test_race.rds"))
  
  
  print(glue("Data analysis for research questions is completed.  RDS files are found in ", RDS_path))
  
}

main(opt$RDS_path)