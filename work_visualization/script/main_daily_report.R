setwd("C:/Users/go_ha/traning/R/work_visualization")
#install.packages("tidyverse")
#install.packages('openxlsx')
library(dplyr)
library(stringr)
library(R6)
library(purrr)
library(openxlsx)
source("script/class_report.R")

#### Definition ####
# Proc target
proc_sprint <- "test",
proc_dates <- list('12-17')

# Input
input_file1 <- "data/inport/target2.csv"
#input_file2 <- ""

# Output
csv_file <- 'data/work/report_daily.csv'
xlsm_file <- 'data/export/report_daily.xlsx'

#### Output daily report with csv ####
# Build daily report
report_daily1 <-
  Report$new(
    input_file1,
    type = "daily",
    sprint = proc_sprint,
    target_dates = proc_dates
  )
#report_daily2 <-
#  Report$new(
#    input_file2,
#    type = "daily",
#    sprint = proc_sprint,
#    target_dates = proc_dates
#  )

# Output daily report with csv
report_daily1$output_file(csv_file)
#report_daily2$output_file(csv_file, mode = "a")

#### Convert daily report to xlsm ####
csv_data <- read.csv(csv_file %>% file(encoding = 'Shift_JIS'))
xlsm_data <- list("daily_update" = csv_data)
write.xlsx(xlsm_data, xlsm_file)
