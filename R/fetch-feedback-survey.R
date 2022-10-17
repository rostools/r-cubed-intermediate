source(here::here("R/_ignore.R"))
library(googledrive)
library(googlesheets4)
library(tidyverse)
library(lubridate)
# conflicted::conflict_prefer("filter", "dplyr")

stop("To prevent accidental sourcing.")

# Import pre-survey data --------------------------------------------------

course_date <- "2021-10"

feedback_survey <- drive_get(id = FEEDBACK_SURVEY_ID) %>%
    read_sheet() %>%
    filter(str_detect(as.character(Timestamp), course_date))

# Any duplicate timestamps?
any(duplicated(feedback_survey$Timestamp))

# Clean up and convert to long form
long_feedback_survey <- feedback_survey %>%
    mutate(across(where(is.list), ~map(., as.character))) %>%
    unnest(cols = where(is.list), keep_empty = TRUE) %>%
    rename(day = `Which of the days is the feedback for?`,
           time_stamp = Timestamp) %>%
    pivot_longer(cols = -c(time_stamp, day), names_to = "question", values_to = "response") %>%
    filter(!is.na(response), !response %in% c("na", "NA", ".", "-")) %>%
    mutate(response = str_remove_all(response, "\n"),
           question = str_remove(question, "\\.\\.\\.\\d+") %>%
               str_replace("\\?\\?", "?"))

# Keep and save the quantitative feedback
set.seed(125643)
quantitative_feedback <- long_feedback_survey %>%
    filter(str_detect(question, "Please complete these questions")) %>%
    group_by(time_stamp) %>%
    mutate(question = str_remove(question, "Please .* course. ") %>%
               str_remove_all("\\[|\\]"),
           id = ids::random_id(1, 5)) %>%
        ungroup() %>%
    select(id, survey_item = question, response)

# Quick check everything was wrangled correctly.
quantitative_feedback %>%
    count(id) %>%
    count(n)

write_csv(quantitative_feedback, here::here(glue::glue("feedback/{course_date}-quantitative.csv")))

# Keep and save the general feedback
overall_feedback <- long_feedback_survey %>%
    filter(str_detect(question, "other feedback")) %>%
    select(response)

write_csv(overall_feedback, here::here(glue::glue("feedback/{course_date}-overall.csv")))

# Keep and save the session specific feedback
session_feedback <- long_feedback_survey %>%
    filter(str_detect(question, "What (could|worked)")) %>%
    mutate(question = question %>%
               str_remove_all('What|session|\\"|\\?') %>%
               str_trim()) %>%
    separate(col = question, into = c("worked_or_improve", "session"),
             sep = "for the") %>%
    mutate(worked_or_improve = snakecase::to_snake_case(worked_or_improve),
           session = session %>%
               str_trim()) %>%
    pivot_wider(names_from = worked_or_improve, values_from = response) %>%
    arrange(day, session) %>%
    select(-time_stamp)

write_csv(session_feedback, here::here(glue::glue("feedback/{course_date}-session-specific.csv")))
