
This is the repo for milestone 3


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


3. Run the following scripts (in order) with the appropriate arguments specified

**In the Milestone_3 folder as working directory**

 **Download data with load_data.R** \
  Rscript scripts/load_data.R --URL="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"
  
  **Wrangle/clean/process the data with process_data.R** \
  Rscript scripts/process_data.R --raw_data="data/adult_data.csv" --processed="adult_data_clean.csv"
  
  **EDA script to export images with EDA_script.R** \
  Rscript scripts/EDA_script.R --path="images"
