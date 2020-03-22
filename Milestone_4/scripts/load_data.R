"This is a script to load the raw data from a URL and save it in the /data folder

Usage: load_data.R --URL=<data_URL> --filepath=<filepath>"  -> doc

#Load libraries and packages 
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(glue)) 
suppressPackageStartupMessages(library(docopt))

opt <- docopt(doc)

#' Loads .csv file from a URL and saves it in a specified file path
#'
#' @param URL The URL to load the .csv file
#' @param filepath A path to save the .csv file loaded from URL
#' @return .csv file 
#' @examples 
#' function("https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data", "data/adult_data.csv")


main <- function(URL, filepath) {
  #Read the file
  data <- suppressMessages(read_csv(url(URL), col_names=FALSE))
  #Save the raw data as a .csv file
  write_csv(data, 'data/adult_data.csv')  
  
  print(glue("The file has been loaded and saved in Milestone_3/data as adult_data.csv"))
  
}
main(opt$URL, opt$filepath)
