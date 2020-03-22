# author: Carleena Ortega and Saelin Bjornson
# date: Mar 15, 2020

# This is a Makefile
# To run make all, folders need to be empty with 'make clean' first

#clean data
clean :
	rm -f data/*.rds
	rm -f data/*.csv
	rm -f images/*.png
	rm -f docs/*.pdf
	rm -f docs/*.html
	rm -f docs/*.txt
	

#make all
all : docs/final_report.html docs/final_report.pdf

#load data
adult_data.csv : scripts/load_data.R
	Rscript scripts/load_data.R --filepath="data/adult_data.csv" --URL="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"

# process data
adult_data_clean.csv : adult_data.csv scripts/process_data.R	
	Rscript scripts/process_data.R --raw_data="data/adult_data.csv" --processed="adult_data_clean.csv"

# Make images with EDA_images_script.R
Plot_1_Distribution_of_Age_by_Sex.png Plot_2_Education_Level_of_50K_or_more_Earners.png Plot_3_Hours_worked_per_week_by_age.png \
Plot_4_Marital_Status_and_Work_Hours.png : adult_data_clean.csv scripts/EDA_images_script.R
	Rscript scripts/EDA_images_script.R --image_path="images/" 
	
# Make RDS with EDA_LM_script.R
hours_full.rds hours_full_NoAge.rds hours_full_NoEducation.rds hours_full_NoRace.rds \
hours_full_NoSex.rds hours_full_NoRelationship.rds test_age.rds test_education.rds test_race.rds \
test_relationship.rds test_sex.rds : adult_data_clean.csv scripts/EDA_LM_script.R
	Rscript scripts/EDA_LM_script.R --RDS_path="data/"


#knit data (specifying just one with make produces all outputs)
docs/final_report.html docs/final_report.pdf : Plot_1_Distribution_of_Age_by_Sex.png Plot_2_Education_Level_of_50K_or_more_Earners.png \
Plot_3_Hours_worked_per_week_by_age.png Plot_4_Marital_Status_and_Work_Hours.png hours_full.rds hours_full_NoAge.rds \
hours_full_NoEducation.rds hours_full_NoRace.rds hours_full_NoSex.rds hours_full_NoRelationship.rds test_age.rds \
test_education.rds test_race.rds test_relationship.rds test_sex.rds scripts/knit_final_report.R 
	Rscript scripts/knit_final_report.R --final_report="docs/final_report.Rmd"

#test data
