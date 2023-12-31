#install.packages("tidyverse")
#install.packages('openxlsx')
library(dplyr)
library(stringr)
library(R6)
library(purrr)
library(openxlsx)
setwd("C:/Users/go_ha/traning/R/work_visualization")

source("script/class_report.R")

# Input
input_file <- "data/inport/target2.csv"

# Output
work_file <- 'data/work/report_daily.csv'
export_file <- 'data/export/report_daily.xlsx'


report_daily <-
  Report$new(
    input_file,
    type = "daily",
    sprint = "test",
    target_dates = list('12-17')
  )
report_daily$output_file(work_file)
report_daily$output_file(work_file, mode = "a")

daily_data <- read.csv(work_file %>% file(encoding = 'Shift_JIS'))

export_data <- list("daily_update" = daily_data)
write.xlsx(export_data, export_file)
