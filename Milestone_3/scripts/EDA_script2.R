"This is a script to do exploratory data analysis on /data/adult_data_clean.csv and to save images to /images

Usage: EDA_script.R --image_path=<path_to_save> --RDS_path=<RDS_path_to_save>" -> doc
##Exact usage from Milestone_3: Rscript scripts/EDA_script.R --image_path="images/" --RDS_path="data/"

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(docopt))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(purrr))

opt <- docopt(doc)

main <- function(image_path, RDS_path) {
  #read the file
  data <- read.csv("data/adult_data_clean.csv", row.names=1)
  
  
  # Research question: Is hours worked per week correlated with age, relationship, education level, or sex?
  
  #The relationship of each separately:
 data4<-as.tibble(read.csv("data/adult_data_clean.csv", row.names=1))
 
 factors<-c(data4$age, data4$relationship, data4$education, data4$sex)
  
 fnc<-
   lm(data4$hours_per_week~factors,data4)
  saveRDS(hours_".x",file=glue(RDS_path,"hours_",factors,".rds"))
 
  map(factors,fnc)
  
  OR 
  
  data<-as.tibble(read.csv("data/adult_data_clean.csv", row.names=1))
  
  factors<-1:seq_along(data %>%  select(age,relationship,education, sex))
  
  fnc<-
    lm(data$hours_per_week~factors,data4)
  saveRDS(hours_(factors),file=glue(RDS_path,"hours_",(factors),".rds"))
  
  map(factors,fnc)
  
  OR 
  
  hours_age<-lm(hours_per_week~age,data) 
  saveRDS(hours_age, file = glue(RDS_path,"hours_age.rds"))
  
  hours_relationship<-lm(hours_per_week~relationship,data) 
  saveRDS(hours_relationship, file = glue(RDS_path,"hours_relationship.rds"))
  
  hours_education<-lm(hours_per_week~education,data) 
  saveRDS(hours_education, file = glue(RDS_path,"hours_education.rds"))
  
  hours_sex<-lm(hours_per_week~sex,data) 
  saveRDS(hours_sex, file = glue(RDS_path, "hours_sex.rds"))
  
  
  #Relationship of all variables together:
  
  hours_age_relationship_educ_sex<-lm(hours_per_week~sex + hours_per_week + education + relationship + age, data) 
  saveRDS(hours_age_relationship_educ_sex, file = glue(RDS_path,"hours_all.rds"))
  
  print(glue("Data analysis done!"))
  
}

main(opt$image_path, opt$RDS_path)