"This is a script to do exploratory data analysis on /data/adult_data_clean.csv and to save images to /images

Usage: EDA_script.R --image_path=<path_to_save> --RDS_path=<RDS_path_to_save>" -> doc
##Exact usage from Milestone_4: Rscript scripts/EDA_script3.R --image_path="images/" --RDS_path="data/"

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(docopt))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(purrr))

opt <- docopt(doc)

main <- function(image_path, RDS_path) {
  #read the file
  data <- read.csv("data/adult_data_clean.csv", row.names=1)
  
  #Plot 1
  df <-select(data, sex, age) %>% mutate(sex = factor(sex, levels=c("Male", "Female"))) %>% group_by(sex)  %>% summarize(mean=mean(age))
  
  
  Plot1 <- data %>% mutate(sex = factor(sex, levels=c("Male", "Female"))) %>%
    ggplot(aes(x=age,fill=sex)) + 
    geom_histogram(alpha=0.8,position="identity") +
    scale_fill_manual(values=c("skyblue2","deeppink4")) + 
    labs(title="Distribution of Age by Sex",x="Age",y="Count") +
    theme_bw() +
    theme(legend.title=element_blank())
  
  ggsave("Plot_1_Distribution_of_Age_by_Sex.png", Plot1, path=image_path)  #save as Plot 1 in path (images folder)
  
  
  #Plot 2
  data_2 <- data
  data_2$education_num <- as.integer(data_2$education_num)
  df <- data_2 %>% select(sex, education_num,income,race)
  df$educ[df$education_num < 10] <- "PS"  #for Post-secondary
  df$educ[df$education_num >= 10] <- "HS"  #for High School, all values lower than or equal to 10
  
  Plot2 <- df %>% filter(income =="over_50K") %>% select(race,educ,sex) %>% group_by(race,educ,sex) %>% tally() %>%
    ggplot(aes(sex, n, fill=educ)) +
    geom_bar(position="fill", stat="identity") +
    theme_bw() +
    scale_fill_manual(values=c("skyblue2","deeppink4"),labels=c("High School","Post-Secondary")) + 
    facet_wrap(~race) +
    labs(title="Education level of 50K or more Earners",fill="Education",y="Percent",x="Sex") 
  
  
  ggsave("Plot_2_Education_Level_of_50K_or_more_Earners.png", Plot2, path=image_path)   #save as Plot 2 in path (Images folder)
  
  
  #Plot 3
  data_3 <- select(data, age, hours_per_week) %>% mutate(Age_level= case_when(age <20 ~ "Under 20",
                                                                              age <30 ~"30s",
                                                                              age <40 ~"40s",
                                                                              age <50 ~"50s",
                                                                              age <60 ~"60s",
                                                                              age <70 ~"70s",
                                                                              age <80 ~"80s",
                                                                              TRUE ~ "90+")) 
  Plot3 <- data_3 %>% mutate(Age_level =fct_relevel(Age_level,"Under 20")) %>%
    ggplot(aes(Age_level, hours_per_week,fill=Age_level)) +
    geom_boxplot(outlier.size=0.2) +
    labs(title="Hours worked per week by age", x="Age", y="Hours per Week") +
    theme_bw() +
    theme(legend.position="none")
  
  ggsave("Plot_3_Hours_worked_per_week_by_age.png", Plot3, path=image_path)  #save as Plot 3 in path (Images folder)
  
  #plot 4
  
  Plot4 <-  data %>% 
    select(hours_per_week,race,marital_status)%>%
    mutate(marital_status = case_when( 
      marital_status == c("Married-AF-spouse","Married-civ-spouse","Married-spouse-absent") ~ "Married",
      TRUE ~ "Single")) %>%
    ggplot()+
    geom_boxplot(aes(marital_status,hours_per_week), outlier.size=0.2) +
    labs(x="Marital Status",y="Hours Worked per Week",
         title="The Relationship between Marital Status and Work Hours")+
    facet_wrap(~race)+ 
    theme_bw() 
  
  ggsave("Plot_4_Marital_Status_and_Work_Hours.png", Plot4, path=image_path) #save as Plot 4 in path (Images folder)
  
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
  

  print(glue("Data analysis for research questions is completed. Images are found in ", image_path, " and RDS files are found in ", RDS_path))
  
}

main(opt$image_path, opt$RDS_path)