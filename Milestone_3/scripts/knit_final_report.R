#Be done in Rmarkdown and should not have any “hard-coded” (use r code chunks and inline r code) numbers and values
#Have an introduction/motivation and description of research question
#Have a section describing your dataset (EDA); make sure you import pngs from the images directory rather than creating them again!
#  Have a section for your methods (placeholder for a linear regression to be done next week)
#Have a section for your results (placeholder for a linear regression to be done next week)
#Have a section for your discussion/conclusion (placeholder for a linear regression to be done next week)
#Be a new, different document than the EDA document you submitted for milestone1 (though you can liberally borrow from your report, particularly the introduction)

"This is a script to knit the draft final_report.Rmd to an html and pdf file"


"This is a script to load the raw data from a URL and save it in the /data folder

Usage: knit_final_report.R --final_report=<final_report_URL> --html=<path_of_html> -- pdf=<path_to_pdf>"  -> doc

#Load libraries and packages 

library(tidyverse)
library(glue)
library(docopt)
library(knitr)

opt <- docopt(doc)

main <- function(final_report,html) {
  final_report <- knit(url(URL), col_names=FALSE)
  
  write.csv(data, 'data/adult_data.csv')  
  
  print(glue("The file has been created as an html and pdf"))
  
}

main(opt$URL)