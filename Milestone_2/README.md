
This is the repo for milestone 2


**Usage**
==================
_Instructions for how to completely reproduce this analysis_

1. Clone this repo.

2. Ensure the following packages are installed:

  - ggplot2
  - tidyverse


3. Run the following scripts (in order) with the appropriate arguments specified

 **Download data with load_data.R** \
  Rscript scripts/load_data.r --URL="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"
  
  **Wrangle/clean/process the data with process_data.R** \
  Rscript scripts/process_data.r --raw_data="Data/adult_data.csv" --processed="adult_data_clean.csv"
  
  **EDA script to export images with EDA_script.R** \
  Rscript scripts/EDA_script.r --path="/images/"
  
  **Knit the draft final report (final_report.Rmd) with knit_final_report.R** \
  Rscript -e "rmarkdown::render('... (etc)
