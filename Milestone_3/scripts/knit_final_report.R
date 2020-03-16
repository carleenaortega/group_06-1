#Be done in Rmarkdown and should not have any “hard-coded” (use r code chunks and inline r code) numbers and values
#Have an introduction/motivation and description of research question
#Have a section describing your dataset (EDA); make sure you import pngs from the images directory rather than creating them again!
#  Have a section for your methods (placeholder for a linear regression to be done next week)
#Have a section for your results (placeholder for a linear regression to be done next week)
#Have a section for your discussion/conclusion (placeholder for a linear regression to be done next week)
#Be a new, different document than the EDA document you submitted for milestone1 (though you can liberally borrow from your report, particularly the introduction)

"This script knits the final report together.

Usage: scripts/knit_final_report.R --final_report=<final_report>" -> doc

library(docopt)

opt <- docopt(doc)

main <- function(final_report) {
  rmarkdown::render(final_report, 
    c("html_document", "pdf_document"))

  print(glue("The html and pdf forms of the final report can be found in the docs folder"))  
  
}

main(opt$final_report)