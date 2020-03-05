
This is the repo for milestone 2


**Usage**
==================
_Instructions for how to completely reproduce this analysis_

1. Clone this repo.

2. Ensure the following packages are installed:

  - ggplot2
  - tidyverse
  - cowplot
  - etc........


3. Run the following scripts (in order) with the appropriate arguments specified

 **Download data with load_data.R** \
  Rscript src/script_name.r --data_url=<url_to_raw_data_file>
  
  **Wrangle/clean/process the data with process_data.R** \
  Rscript src/script_name.r --argument_name=<argument> ... (etc)
  
  **EDA script to export images with EDA_script.R** \
  Rscript src/script_name.r --argument_name=<argument> ... (etc)
  
  **Knit the draft final report (final_report.Rmd) with knit_final_report.R** \
  Rscript -e "rmarkdown::render('... (etc)
