"This is a script to load the raw data from a URL and save it in the /data folder

Usage: load_data.R --URL=<data_URL> --filepath=<filepath>"  -> doc

#Load libraries and packages 
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(glue)) 
suppressPackageStartupMessages(library(docopt))

opt <- docopt(doc)

main <- function(URL, filepath) {
  #Read the file
  data <- read_csv(url(URL), col_names=FALSE)
  #Save the raw data as a .csv file
  write_csv(data, 'data/adult_data.csv')  
  
  print(glue("The file has been loaded and saved in Milestone_3/data as adult_data.csv"))
  
}
main(opt$URL, opt$filepath)
