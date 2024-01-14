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
sprint_result <- "test"
sprint_plan <- "P74.2"

# Input
input_result_file1 <- "data/inport/result_jira.csv"
#input_result_file2 <- ""
input_plan_file1 <- "data/inport/result_jira.csv"
#input_plan_file2 <- ""
master_result_file <- 'data/master/report_result_all.csv'
master_plan_file <- 'data/master/report_plan_all.csv'

# Output
csv_file_result <- 'data/work/report_result.csv'
csv_file_plan <- 'data/work/report_plan.csv'
xlsm_file_result_plan <- 'data/export/report_sprint.xlsx'

#### Output result report with csv ####
# Build result report
report_result1 <-
  Report$new(input_result_file1, type = "result", sprint = sprint_result)
#report_result2 <-
#  Report$new(input_result_file2, type = "result", sprint = sprint_result)

# Output result report with csv
report_result1$output_file(csv_file_result)
#report_result2$output_file(csv_file_result, mode = "a")

#### Update result report master ####
current_result_data <-
  read.csv(file(csv_file_result, encoding = 'Shift_JIS'))
master_result_data <-
  read.csv(file(master_result_file, encoding = 'Shift_JIS'))
master_result_data <-
  master_result_data %>% filter(proc_sprint != !!sprint_result)
update_result_data <-
  bind_rows(current_result_data, master_result_data)
write.table(
  update_result_data,
  file = master_result_file,
  sep = ",",
  row.names = FALSE,
  quote = FALSE,
  fileEncoding = 'Shift_JIS'
)

#### Output plan report with csv ####
# Build plan report
report_plan1 <-
  Report$new(input_plan_file1, type = "plan", sprint = sprint_plan)
#report_plan2 <-
#  Report$new(input_plan_file2, type = "plan", sprint = sprint_plan)

# Output plan report with csv
report_plan1$output_file(csv_file_plan)
#report_plan2$output_file(csv_file_plan, mode = "a")

#### Update plan report master ####
current_plan_data <-
  read.csv(file(csv_file_plan, encoding = 'Shift_JIS'))
master_plan_data <-
  read.csv(file(master_plan_file, encoding = 'Shift_JIS'))
master_plan_data <-
  master_plan_data %>% filter(proc_sprint != !!sprint_plan)
update_plan_data <- bind_rows(current_plan_data, master_plan_data)
write.table(
  update_plan_data,
  file = master_plan_file,
  sep = ",",
  row.names = FALSE,
  quote = FALSE,
  fileEncoding = 'Shift_JIS'
)

#### Convert result & plan report to xlsm ####
updated_result_data <-
  read.csv(file(master_result_file, encoding = 'Shift_JIS'))
updated_plan_data <-
  read.csv(file(master_plan_file, encoding = 'Shift_JIS'))

joined_data <-
  full_join(
    updated_plan_data,
    updated_result_data,
    by = c("proc_sprint", "issue.key"),
    suffix = c(".plan", ".result")
  )
export_data <- list("sprint_result" = joined_data)
write.xlsx(export_data, xlsm_file_result_plan)
