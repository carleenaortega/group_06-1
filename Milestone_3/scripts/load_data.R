
"This is a script to load the raw data from a URL and save it in the /Data folder

Usage: load_data.R --URL=<data_URL>"  -> doc
#Data URL to use: https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data


#Load libraries and packages 

library(tidyverse)
library(glue)
library(docopt)

opt <- docopt(doc)

main <- function(URL) {
  data <- read_csv(url(URL), col_names=FALSE)
  
  write.csv(data, 'Data/adult_data.csv')  
  
  print(glue("The file has been loaded and saved in Milestone_3/Data as adult_data.csv"))
  
}

main(opt$URL)