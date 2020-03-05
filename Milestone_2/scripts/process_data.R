#This is a script to process the raw data

#Have at least TWO command-line arguments (at minimum, you may have more as well)
#Take in the path to the raw data (in the data folder) as a command-line argument
#Take in the filename to where the wrangled data should be saved as a command-line argument
#Wrangle/clean/process your raw data and save a new version of data for later analysis
#Run without any intervention from the user after running the script from a terminal/command prompt
#Print a helpful message to the terminal informing the user that the script completed successfully

"This is a script to process the raw adult_data.csv and save in /Data directory

Usage: process_data.R --raw_data=<path_to_raw> --processed=<file_name>"
#Path to raw = Milestone_2/Data/adult_data.csv and processed = adult_data_clean.csv

library(tidyverse)
library(glue)

main <- function(raw_data, processed) {
  raw <- read_csv(raw_data, col_names=FALSE)
  
  #fix the data
  adult_data <- raw %>% rename("age"=X1,"workclass"=X2,"fnlwgt"=X3,"education"=X4,
                                  "education_num"=X5,"marital_status"=X6,"occupation"=X7,"relationship"=X8,
                                  "race"=X9,"sex"=X10,"capital_gain"=X11,"capital_loss"=X12,"hours_per_week"=X13,
                                  "country"=X14,"income"=X15) %>%    #give appropriate column names
    
    mutate(income=recode(income, ">50K"="over_50K", "<=50K"="under_50K")) %>%  #re-write in better format
    
    mutate_at(vars("workclass","education","marital_status","occupation","relationship","race","sex","country"), na_if, "?") #change "?" to NAs
  
  adult_data$education_num <-as.factor(adult_data$education_num) #change education level to factor 
  
  write.csv(processed, 'Milestone_2/Data/') 
  
  print(glue("the raw data", raw_data, "has been processed and saved as", processed, "in Milestone_2/Data"))  

}

main()
