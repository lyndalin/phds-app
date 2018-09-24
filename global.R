# Data visualization for PhD careers and salaries using Shiny (global)

library(tidyverse)
library(plotly)
library(reshape2)
library(htmlwidgets)
library(data.table)
library(DT) #datatables
library(shiny)
library(shinydashboard)
library(shinythemes)

#Load dataset to use (total number of PhDs per year, salaries, and postgrad commitments)

# 1-Number of PhDs per field per year
docs_df <- read.csv("data/docs_recipients_1957_2016_SE_broad_detailed_latest.csv", header=TRUE)

# Total PhDs - Detailed field comparisons 
docs_df_detailed_fields <- docs_df %>% filter(Field_comparison == 1)

# 2-Salaries
salaries_df <- read.csv("data/salaries_2016_latest.csv", header=TRUE)

# Convert from wide to long
salaries_df_long <- melt(salaries_df, 
                         id.vars = c("Science_Engineering_Field", "Broad_Field", "Field", "Year", "SE_comparison", "Broad_Field_comparison", "Field_comparison"), 
                         measure.vars = c("Academia", "Industry", "Government", "Nonprofit", "Other"), 
                         variable.name="Sector", 
                         value.name = "Salary")

# Salaries - Detailed field comparisons
salaries_df_long_detailed_fields <- salaries_df_long %>% filter(Field_comparison == 1)

# 3-Areas PhDs go to (postgrad commitments)
postgrad_commitments_df <- read.csv("data/postgrad_2016_latest.csv", header=TRUE)

# Add columns for percents (e.g. percent of USA doctorates going into postdocs out of all people who have definite commitments)
postgrad_commitments_df_wide <- postgrad_commitments_df %>% mutate(USA_postdoctoral_percent = round(USA_postdoctoral_n / Definite_commitments_n_minus_unknown, digits=2), 
                                                                   USA_academic_percent = round(USA_academic_n / Definite_commitments_n_minus_unknown, digits=2), 
                                                                   USA_industry_percent = round(USA_industry_n / Definite_commitments_n_minus_unknown, digits=2), 
                                                                   USA_other_percent = round(USA_other_n / Definite_commitments_n_minus_unknown, digits=2), 
                                                                   Abroad_percent = round(Abroad_n / Definite_commitments_n_minus_unknown, digits=2))

# Convert from wide to long using data.table (can add two columns when converting to long -- number of doctorates AND percent of doctorates)
postgrad_commitments_df_long <- melt(setDT(postgrad_commitments_df_wide), 
                                     measure.vars = list(c("USA_postdoctoral_n", "USA_academic_n", "USA_industry_n", "USA_other_n", "Abroad_n"),
                                                         c("USA_postdoctoral_percent", "USA_academic_percent", "USA_industry_percent", "USA_other_percent", "Abroad_percent")), 
                                     variable.name='var', 
                                     value.name = c("Number_of_Doctorates", "Percent_of_Doctorates"))
postgrad_commitments_df_long[var == 1, var := "USA_postdoctoral"]
postgrad_commitments_df_long[var == 2, var := "USA_academic"]
postgrad_commitments_df_long[var == 3, var := "USA_industry"]
postgrad_commitments_df_long[var == 4, var := "USA_other"]
postgrad_commitments_df_long[var == 5, var := "Abroad"]

# Change name of var column
colnames(postgrad_commitments_df_long)[which(names(postgrad_commitments_df_long)=="var")] <- "Area"

# Sectors PhDs go to (postgrad commitments) - Detailed field comparisons
postgrad_commitments_df_long_detailed_fields <- postgrad_commitments_df_long %>% filter(Field_comparison == 1)

