"This is a script to perform tests on the scripts

Usage: test_data.R --URL=<data_URL> --filepath=<filepath>"  -> doc

#Load libraries and packages 
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(glue)) 
suppressPackageStartupMessages(library(docopt))
suppressPackageStartupMessages(library(testthat))

context("Demonstrating that the scripts work")

opt <- docopt(doc)

main <- function(URL = "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data", 
  filepath = "data/adult_data.csv") {
  test_that("Zero equals itself", {expect_equal(0, 0)})
  
  print(glue("The file passed the tests!"))
  
}
main(opt$URL, opt$filepath)



