"This script knits the final report together.

Usage: scripts/knit_final_report.R --final_report=<final_report>" -> doc

suppressPackageStartupMessages(library(docopt))
suppressPackageStartupMessages(library(glue))

opt <- docopt(doc)

main <- function(final_report) {
  
  rmarkdown::render(final_report, "all")

  print(glue("The html and pdf forms of the final report can be found in the docs folder"))  
  
}

main(opt$final_report)