
This is the repo for milestone 2


**Usage**
==================
_Instructions for how to completely reproduce this analysis_

1. Clone this repo.

2. Ensure the following packages are installed:

  - ggplot2
  - tidyverse
  - glue
  - docopt


3. Change the working directory to Milestone_2, and run the following scripts (in order) with the appropriate arguments specified

 **Download data with load_data.R** \
  Rscript scripts/load_data.R --URL="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"
  
  **Wrangle/clean/process the data with process_data.R** \
  Rscript scripts/process_data.R --raw_data="Data/adult_data.csv" --processed="adult_data_clean.csv"
  
  **EDA script to export images with EDA_script.R** \
  Rscript scripts/EDA_script.R --path="Images"
