# author: Carleena Ortega and Saelin Bjornson
# date: Mar 15, 2020

# This is a Makefile

all: docs/final_report.html docs/final_report.pdf

#load data
adult_data.csv : scripts/load_data.R
	Rscript scripts/load_data.R --filepath="data/adult_data.csv" --url_to_read="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"

# process data
adult_data_clean.csv : scripts/process_data.R	
	Rscript scripts/process_data.R --raw_data="data/adult_data.csv" --processed="adult_data_clean.csv"

# explore data
Plots.png : scripts/EDA_script.R
	Rscript scripts/EDA_script.R --image_path="images/" --RDS_path="data/"

#knit data
final_report.html final_report.pdf : data/adult_data.csv data/adult_data_clean.csv scripts/knit_final_report.R
	Rscript scripts/knit_final_report.R --final_report="docs/final_report.Rmd"

#clean data
clean :
	rm -f data/*
	rm -f images/*
	rm -f docs/*.pdf
	rm -f docs/*.html
	
#test data
