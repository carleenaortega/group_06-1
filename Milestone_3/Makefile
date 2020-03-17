# author: Carleena Ortega and Saelin Bjornson
# date: Mar 15, 2020

# This is a Makefile
# too run make all, folders need to be empty with 'make clean' first

#clean data
clean :
	rm -f data/*
	rm -f images/*
	rm -f docs/*.pdf
	rm -f docs/*.html
	rm -f docs/*.txt
	

#make all
all : final_report.html final_report.pdf

#load data
adult_data.csv : scripts/load_data.R
	Rscript scripts/load_data.R --filepath="data/adult_data.csv" --URL="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"

# process data
adult_data_clean.csv : adult_data.csv scripts/process_data.R	
	Rscript scripts/process_data.R --raw_data="data/adult_data.csv" --processed="adult_data_clean.csv"

# explore data (specifying just one with make produces all outputs)
# This script has 13 outputs, and when specify just one with make, e.g 'make hours_sex.rds', all outputs are produced. 
# However, in 'make all this' script repeates 13 times, once for each output, even though every run produces all outputs. Still works, just makes everything much slower. 
# I've tried specifying just one output in the rule (keeping all the 13 files as dependencies in the next script), but then doesn't work at all with 'make all' 
Plot_1_Distribution_of_Age_by_Sex.png Plot_2_Education_Level_of_50K_or_more_Earners.png Plot_3_Hours_worked_per_week_by_age.png \
Plot_4_Marital_Status_and_Work_Hours.png hours_age.rds hours_relationship.rds hours_education.rds hours_sex.rds \
hours_all.rds : adult_data_clean.csv scripts/EDA_script.R
	Rscript scripts/EDA_script.R --image_path="images/" --RDS_path="data/"

#knit data (specifying just one with make produces all outputs)
# Like above, this also runs twice, once for each output. 
final_report.html final_report.pdf : docs/final_report.Rmd Plot_1_Distribution_of_Age_by_Sex.png Plot_2_Education_Level_of_50K_or_more_Earners.png \
Plot_3_Hours_worked_per_week_by_age.png Plot_4_Marital_Status_and_Work_Hours.png hours_age.rds \
hours_relationship.rds hours_education.rds hours_sex.rds hours_all.rds scripts/knit_final_report.R 
	Rscript scripts/knit_final_report.R --final_report="docs/final_report.Rmd"

#test data
