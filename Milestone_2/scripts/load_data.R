#Have at least ONE command-line argument (at minimum, you may have more as well)
#Take in the raw data URL as a command-line argument.
#If you cannot get a URL to your dataset, you can store your dataset in this public repository and then get the URL for this script
#Run without any intervention from the user after running the script from a terminal/command prompt:
#  Rscript src/script_name.r --data_url=<url_to_raw_data_file>
#  Download and save the data in the data directory
#Print a helpful message to the terminal informing the user that the script completed successfully

"This is a script to load the raw data froman URL and save it in the /Data directory

Usage: load_data.R --URL=<data_URL>"

#Load libraries and packages 
library(tidyverse)
library(glue)

main <- function(URL="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data") {
  
  name <- read_csv(url(URL), col_names=FALSE)
  
  write.csv(name, 'Milestone_2/Data/adult_data.csv' )  
  
  print(glue("the file has been loaded and saved in Milestone_2/Data as adult_data.csv"))
  
}

main()





