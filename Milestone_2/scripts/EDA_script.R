#This is a script for exploratory data analysis of our procesed data

#Perform the EDA you did in week 1 and save the plots as separate png files (these will be imported in by your final report)
#Take in a path where exported images should be saved (likely images) as a command-line argument
#Run without any intervention from the user after running the script from a terminal/command prompt
#Print a helpful message to the terminal informing the user that the script completed successfully

"This is a script to do exploratory data analysis on /Data/adult_data_clean.csv and to save images to /images

Usage: EDA_script.R --path=<path_to_save>" -> doc
#Path to save images = Milestone_2/Images


library(tidyverse)
library(ggplot2)
library(docopt)
library(glue)

opt <- docopt(doc)

main <- function(path) {
  data <- read.csv("Milestone_2/Data/adult_data_clean.csv",row.names=1)
  
  #Plot 1
  df <-select(data, sex, age) %>% mutate(sex = factor(sex, levels=c("Male", "Female"))) %>% group_by(sex)  %>% summarize(mean=mean(age))
  
  
 Plot1 <- data %>% mutate(sex = factor(sex, levels=c("Male", "Female"))) %>%
    ggplot(aes(x=age,fill=sex)) + 
    geom_histogram(alpha=0.8,position="identity") +
    scale_fill_manual(values=c("skyblue2","deeppink4")) + 
    labs(title="Distribution of Age by Sex",x="Age",y="Count") +
    theme_bw() +
    theme(legend.title=element_blank())
 
    ggsave("Plot_1.png", Plot1, path=path)  #save as Plot 1 in path (Milestone_2/images)
  
  
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
    labs(title="Education level of people making over 50K",fill="Education",y="Percent",x="Sex") 
  
  
    ggsave("Plot_2.png", Plot2, path=path)   #save as Plot 2 in path (Milestone_2/images)
  

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
  
    ggsave("Plot_3.png", Plot3, path=path)  #save as Plot 3 in path (Milestone_2/images)
  
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
 
  ggsave("Plot_4.png", Plot4, path=path) #save as Plot 4 in path (Milestone_2/images)
  
 
  print(glue("Plots 1-4 have been saved in ", path))
}

main(opt$path)