source(here::here("R/ignore.R"))
library(googledrive)
library(googlesheets4)
library(tidyverse)
conflicted::conflict_prefer("filter", "dplyr")

# Import pre-survey data --------------------------------------------------

presurvey <- drive_get(id = PRE_SURVEY_ID) %>%
    read_sheet(
        skip = 1,
        col_names = c(
            "timestamp",
            "email",
            "full_name",
            "research_position",
            "city_work_in",
            "research_topic",
            "perceived_skill_r",
            "perceived_skill_data_analysis",
            "perceived_skill_programming",
            "perceived_skill_data_management",
            "perceived_skill_git",
            "perceived_skill_rmd",
            "previously_used_stat_programs",
            "check_setup_output",
            "check_project_setup_output",
            "course_expectations",
            "expectations_match_syllabus",
            "matched_assumptions",
            "accept_conduct",
            "feedback_worked_well",
            "feedback_to_improve",
            "encounter_problems",
            "describe_problems",
            "when_available_for_help"
        )
    )

nrow(presurvey)
View(presurvey)

presurvey_feedback_data <- presurvey %>%
    select(-when_available_for_help, -describe_problems, -encounter_problems,
           -check_project_setup_output, -check_setup_output,
           -full_name, -email, -timestamp) %>%
    mutate(across(everything(), ~ str_remove_all(.x, '\\n|\\"')))

write_csv(presurvey_feedback_data, here::here("feedback/2020-09-presurvey-feedback.csv"))
