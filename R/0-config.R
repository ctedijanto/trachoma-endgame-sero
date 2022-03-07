### R configuration file -----
# for trachoma serology endgame analyses
# Christine Tedijanto christine.tedijanto@ucsf.edu
# last updated: 03/01/2022
### ----------------------

## load packages -----
# general
library(tidyverse)

# parallel processes
library(doParallel) # age seroprevalence curves
registerDoParallel(cores = 4)

#library(foreach)
#library(mgcv)

# bayesian
#library(bayesplot)
#library(pbapply)
#library(rstanarm)
library(splines) # for bs() function

# figures
library(cowplot)
#library(viridis)

## quick functions -----
expit <- function(x){exp(x)/(1+exp(x))}
'%ni%' <- Negate('%in%')

## figure prep -----

# set order of location + year
location_year_name_order <- c("Alefa, Ethiopia 2017", "Andabet, Ethiopia 2017", "Dera, Ethiopia 2017", "Woreta town, Ethiopia 2017",
                              "Wag Hemra, Ethiopia 2016", "Wag Hemra, Ethiopia 2017", "Wag Hemra, Ethiopia 2018", "Wag Hemra, Ethiopia 2019",
                              "Kongwa, Tanzania 2012", "Kongwa, Tanzania 2013", "Kongwa, Tanzania 2014", "Kongwa, Tanzania 2015",
                              "Dosso, Niger Spring 2015", "Dosso, Niger Fall 2015", "Dosso, Niger 2016",  "Dosso, Niger 2017",
                              "Dosso, Niger 2018", "Matameye, Niger 2013", "Kongwa, Tanzania 2018", 
                              "Wag Hemra, Ethiopia TAITU 2018", "Mchinji, Malawi 2014", "Chikwawa, Malawi 2014")

# set colors
# different color for each location
# within location, darker for more recent observations
# palette below based on Paul Tol's muted: https://cran.r-project.org/web/packages/khroma/vignettes/tol.html
# tool for creating color gradients: https://www.cssfontstack.com/oldsites/hexcolortool/
location_year_name_colors <- c("Alefa, Ethiopia 2017" = "#DDCC77", # sand
                               "Andabet, Ethiopia 2017" = "#44AA99", #teal
                               "Dera, Ethiopia 2017" = "#88CCEE", # cyan 
                               "Woreta town, Ethiopia 2017" = "#CC6677", # rose
                               "Wag Hemra, Ethiopia 2016" = "#F791E6", 
                               "Wag Hemra, Ethiopia 2017" = "#C45EB3",
                               "Wag Hemra, Ethiopia 2018" = "#912B80", 
                               "Wag Hemra, Ethiopia 2019" = "#771166", # purple original: #AA4499
                               "Kongwa, Tanzania 2012" = "#5EC480", 
                               "Kongwa, Tanzania 2013" = "#2B914D", 
                               "Kongwa, Tanzania 2014" = "#005E1A", 
                               "Kongwa, Tanzania 2015" = "#004400", # green original: #117733
                               "Dosso, Niger Spring 2015" = "#9988EE", 
                               "Dosso, Niger Fall 2015" = "#6655BB", 
                               "Dosso, Niger 2016" = "#4D3CA2", 
                               "Dosso, Niger 2017" = "#1A096F", 
                               "Dosso, Niger 2018" = "#000055", # indigo original: #332288
                               "Matameye, Niger 2013" = "#6699CC", # light blue
                               "Kongwa, Tanzania 2018" = "#999933", # olive
                               "Wag Hemra, Ethiopia TAITU 2018" = "#882255", # wine
                               "Mchinji, Malawi 2014" = "#555555",# dark grey
                               "Chikwawa, Malawi 2014" = "grey" # light gray
                               ) 

## local file paths -----
untouched_data_path <- "data/0-untouched"
temp_data_path <- "data/1-temp"
output_path <- "output"