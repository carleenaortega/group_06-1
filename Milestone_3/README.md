
This is the repo for Milestone 3


**Usage**
==================
_Instructions for how to completely reproduce this analysis_

1. Clone this repo.

2. Ensure the following packages are installed:

  - ggplot2
  - tidyverse
  - glue
  - docopt
  - broom
  - tibble


3. To replicate this analysis, clone this repository, navigate to the `Milestone_3` folder in your terminal, and type in the following commands (in order):

**In the Milestone_3 folder as working directory**

 **Download data with load_data.R** \
  Rscript scripts/load_data.R --URL="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data" --filepath=docs/adult_data.csv
  
  **Wrangle/clean/process the data with process_data.R** \
  Rscript scripts/process_data.R --raw_data="data/adult_data.csv" --processed="adult_data_clean.csv"
  
  **EDA script to export images with EDA_script.R** \
  Rscript scripts/EDA_script.R --path="images"

  **Knit the .Rmd final report into pdf and html documents** \
  Rscript scripts/knit_final_report.R --final_report="docs/final_report.Rmd"
  
  