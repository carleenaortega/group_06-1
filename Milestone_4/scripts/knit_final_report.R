"This script knits the final report together.

Usage: scripts/knit_final_report.R --final_report=<final_report>" -> doc

suppressPackageStartupMessages(library(docopt))
suppressPackageStartupMessages(library(glue))

opt <- docopt(doc)

#' knits final_report.Rmd to pdf and html outputs
#'
#' @param final_report The path to the final report Rmd to knit
#' @return final_report.pdf and final_report.html outputs
#' @examples 
#' function("docs/final_report.Rmd")

main <- function(final_report) {
  
  rmarkdown::render(final_report, "all")

  print(glue("The html and pdf forms of the final report can be found in the docs folder"))  
  
}

main(opt$final_report)