# Introduction


Hello!! We are STAT 547M Students (Saelin and Carleena) and this is our group project repository.

You will find our milestone activitities in this repo as follows:

|Milestone|Status|Link|Tags
| ----------- | ----------- | ----------- |----------- |
|1|Completed|[Milestone 1 Webpage](https://stat547-ubc-2019-20.github.io/group_06/Milestone_1/Milestone-1.html)|[Milestone 1 Complete](https://github.com/STAT547-UBC-2019-20/group_06/releases/tag/Milestone_1)| 
|2|Completed|[Milestone 2 Repo](https://github.com/STAT547-UBC-2019-20/group_06/tree/master/Milestone_2) | [Milestone 2 completed](https://github.com/STAT547-UBC-2019-20/group_06/releases/tag/MS2Complete) |
|3|Completed|[Milestone 3 Repo](https://github.com/STAT547-UBC-2019-20/group_06/tree/master/Milestone_3) |[MS3Completed](https://github.com/STAT547-UBC-2019-20/group_06/releases/tag/MS3v1.0)| 
|4|Completed|[Milestone 4 Repo](https://github.com/STAT547-UBC-2019-20/group_06/tree/master/Milestone_4) [Milestone 4 html](https://stat547-ubc-2019-20.github.io/group_06//Milestone_4/docs/final_report.html)|[Milestone 4 Completed](https://github.com/STAT547-UBC-2019-20/group_06/releases/tag/MS4v1.0)|
|5|Completed|[App2.R](http://127.0.0.1:8050) *Note: only works after going through usage in Milestone_5 folder*||

# Dashboard Proposal

## Description
This dashboard will allow the user to graphically explore the effects of several factors (e.g. age, marital status, education level, and race) on the number of hours worked per week by selecting the appropriate option in the dropdown menu. 

Selecting a categorical variable (race, marital status, or education level) will display two plots, a box plot and a density plot, with groups of that variable on the x-axis and hours worked per week on the y-axis (panel 1 in sketch below). A "Separate by sex" checkbox will determine if the user wants to display the information separated by sex, side-by-side on the plot (panel 2 in sketch). The sexes will be colour coded as blue for men and red for women. A slider is included to filter the data displayed to the audience's preferred age range. 

In contrast to the categorical variables, selecting age from the dropdown menu will instead produce a line graph, with age on the x-axis and hours worked per week on they-axis (panel 3 in sketch). Selecting "Separate by sex" will produce two trend lines, one for women (red) and one for men (blue). The age slider will also be included to filter the data to the user's preferred age range, which will dynamically change the x-axis to that range. 

## Usage Scenario

Mary is in the research team of Employment and Social Development Canada. She and her team were asked to [understand] the factors that influence work force productivity to [identify] areas that require improvement and hopefully [maximize] productivity of the country. She wants to [explore] the dataset to accomplish this goal. When Mary explores the dashboard, she will see an overview of marital status' effect on work hours for individuals of all ages, which she can change to educational level, or race using the dropdown menu). She can then use the slider to filter the dataset to a certain age group she wishes to explore. If she wants to further separate the groups by sex, she may do so by ticking the "separate by sex" box. With this, she may observe that married people tend to work more hours especially during their 40's to 60's. This may mean that workers with a family tend to spend more time at work to provide for their families at the cost of spending time with their families. This could help Mary and her team to provide policies or incentives for companies or employees within this group to have a better work-life balance.

## Example sketch

![Dashboard Design](https://github.com/STAT547-UBC-2019-20/group_06/blob/master/Milestone_4/Dashboard.jpg?raw=true)

# Acknowledgement

The data set used is donated by Silicon Graphics from the University of California Irvine Machine Learning Repository
 
