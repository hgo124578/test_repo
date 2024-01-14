source("data/master/def_sprint.R")

Report <- R6Class(
  "Report",
  public = list(
    initialize = function(source_file,
                          output_columns,
                          additional_columns,
                          sprint,
                          type,
                          regex = '[0-9][0-9]-[0-9][0-9]',
                          sp_unit = 1,
                          target_dates = NULL) {
      private$.data <- read.csv(file(source_file, encoding = 'Shift_JIS'))
      if (type == "daily") {
        private$.output_columns <-
          c(
            "name",
            "team",
            "sprint",
            "issue.key",
            "status",
            "summary",
            "sp_h",
            "spent_sprint",
            "spent_date"
          )
        private$.additional_columns <-
          c("spent_sprint", "spent_date")
      } else if (type == "result") {
        private$.output_columns <-
          c(
            "proc_sprint",
            "team",
            "assignee",
            "issue.key",
            "issue.type",
            "status",
            "summary",
            "story_point",
            "story_point_h",
            "epic",
            "spent_sprint",
            "spent_all"
          )
        private$.additional_columns <-
          c("story_point", "story_point_h", "spent_sprint", "spent_all")
      } else if (type == "plan") {
        private$.output_columns <-
          c(
            "proc_sprint",
            "team",
            "assignee",
            "issue.key",
            "issue.type",
            "status",
            "summary",
            "story_point",
            "story_point_h",
            "epic"
          )
        private$.additional_columns <-
          c("story_point", "story_point_h")
      }
      private$.sprint <- sprint
      private$.sprint_dates <- def_sprint_dates
      private$.target_dates <- target_dates
      private$.sp_unit <- sp_unit
      private$.regex <- regex
      private$.build_report(type)
      write.table(
        private$.data,
        file = "debug.csv",
        sep = ",",
        row.names = FALSE,
        quote = FALSE
      )
    },
    output_file = function(file, mode = "w") {
      switch(mode,
             "w" = {
               write.table(
                 private$.data %>% select(private$.output_columns),
                 file = file,
                 sep = ",",
                 row.names = FALSE,
                 quote = FALSE,
                 fileEncoding = 'Shift_JIS'
               )
             },
             "a" = {
               write.table(
                 private$.data %>% select(private$.output_columns),
                 file = file,
                 sep = ",",
                 row.names = FALSE,
                 quote = FALSE,
                 col.names = FALSE,
                 append = TRUE,
                 fileEncoding = 'Shift_JIS'
               )
             })
    }
  ),
  private = list(
    .data = NULL,
    .output_columns = list(),
    .additional_columns = list(),
    .sprint = NULL,
    .sprint_dates = NULL,
    .target_dates = list(),
    .sp_unit = 1,
    .regex = NULL,
    .build_report = function (type) {
      private$.data <-
        private$.data %>% left_join(read.csv(file("data/master/member.csv", encoding =
                                                    'Shift_JIS')), by = c("name" = "name"))
      private$.data <-
        private$.data %>% mutate(sp_h = sp * private$.sp_unit)
      for (column in private$.additional_columns) {
        if (column == "spent_sprint") {
          private$.build_sum_dates(mode = "sprint")
        } else if (column == "spent_date") {
          private$.build_sum_dates(mode = "date")
        } else if (column == "spent_all") {
          private$.build_sum_date()
        } else if (column == "story_point") {
        } else if (column == "story_point_h") {
        }
      }
      if (type == "result") {
        private$.data <- private$.data %>% filter(sum_sprint > 0)
      }
      private$.data <-
        private$.data %>% mutate(proc_sprint = private$.sprint)
    },
    .clean_log = function (data, target_date = private$.regex) {
      ifelse(str_detect(data, target_date),
             as.numeric(str_replace_all(data, paste0(target_date, ':'), "")) ,
             0)
    },
    .build_sum_dates = function (mode) {
      column_name = ifelse(mode == "sprint", "spent_sprint", 'spent_date')
      if (mode == "sprint") {
        dates <- private$.sprint_dates
      } else{
        dates <- private$.target_dates
      }
      map(.x = dates,
          .f = ~ private$.build_sum_date(target_date = .x))
      private$.data <- private$.data %>%
        mutate(!!column_name := select(., starts_with("wk_sum_")) %>%
                 rowSums(na.rm = TRUE)) %>%
        select(-starts_with("wk_sum_"))
    },
    .build_sum_date = function (target_date = private$.regex) {
      column_name = ifelse(target_date == private$.regex,
                           'sum_all',
                           paste0('wk_sum_', target_date))
      private$.data <- private$.data %>%
        mutate(across(starts_with("log"), .names = "wk_{.col}"))  %>%
        mutate(across(
          starts_with("wk_log"),
          ~ private$.clean_log(.x, target_date)
        )) %>%
        mutate(!!column_name := select(., starts_with("wk_log")) %>%
                 rowSums(na.rm = TRUE))  %>%
        select(-starts_with("wk_log"))
    }
  )
)