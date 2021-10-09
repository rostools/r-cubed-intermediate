source(here::here("R/ignore.R"))
library(googledrive)
library(googlesheets4)
library(tidyverse)
library(lubridate)
conflicted::conflict_prefer("filter", "dplyr")

# Import pre-survey data --------------------------------------------------

# To get the output to rename the columns
# presurvey <- drive_get(id = PRE_SURVEY_ID) %>%
#     read_sheet()
# datapasta::vector_paste(names(presurvey))

renaming_columns <- tibble::tribble(
    ~original_column_names, ~new_column_names,
    "Timestamp", "timestamp",
    "Email Address", "email",
    "What is your full name?", "full_name",
    "What is your formal position?", "research_position",
    "What city do you work in or nearest to?", "city_work_in",
    "Very briefly, what is your research topic(s)?", "research_topic",
    "How do you perceive your skill/knowledge of... [using R?]", "perceived_skill_r",
    "How do you perceive your skill/knowledge of... [data analysis in general?]", "perceived_skill_data_analysis",
    "How do you perceive your skill/knowledge of... [programming in general?]", "perceived_skill_programming",
    "How do you perceive your skill/knowledge of... [managing data in general?]", "perceived_skill_manage_data",
    "How do you perceive your skill/knowledge of... [formal version control (e.g. Git)?]", "perceived_skill_git",
    "How do you perceive your skill/knowledge of... [writing in or using R Markdown?]", "perceived_skill_rmd",
    "What programs have you previously used for data analysis?", "previously_used_stat_programs",
    "Copy and paste the results of your \"r3::check_setup()\" into the text box below.", "check_setup_output",
    "Copy and paste the results of your \"r3::check_project_setup()\" into the text box below.", "check_project_setup_output",
    "What do you expect to learn from this course and what would you like to be able to do afterward with what you've learned?", "course_expectations",
    "Does your expectations match with what is described in the syllabus?", "expectations_match_syllabus",
    "Does our \"assumptions about who you are\" (in the syllabus) match with who you actually are? Why or why not?", "matched_assumptions",
    "Do you accept the conditions laid out in the Code of Conduct?", "accept_conduct",
    "In your opinion, what worked well?", "feedback_worked_well",
    "In your opinion, what could be improved?", "feedback_to_improve",
    "Did you encounter any problems during the pre-course tasks?", "encounter_problems",
    "Please describe the problems you've had.", "describe_problems",
    "Which dates would you be available for a video call to help with the problems?", "when_available_for_help",
    "What gender do you identify with?", "gender_identity",
    "How often do you currently use: [dplyr]", "uses_dplyr",
    "How often do you currently use: [tidyr]", "uses_tidyr",
    "How often do you currently use: [pipe (%>%)]", "uses_pipe",
    "How often do you currently use: [GitHub/GitLab and Git]", "uses_git_github",
    "How often do you currently use: [R Markdown]", "uses_rmarkdown",
    "How often do you currently use: [purrr]", "uses_purrr",
    "How often do you currently use: [tidyverse]", "uses_tidyverse",
    "How often do you currently use: [vroom/readr]", "uses_vroom"
  )

presurvey <- drive_get(id = PRE_SURVEY_ID) %>%
    read_sheet() %>%
    set_names(renaming_columns$new_column_names)
# nrow(presurvey)
# View(presurvey)

presurvey_current <- presurvey %>%
    filter(year(timestamp) == "2021", month(timestamp) %in% 9:10)
nrow(presurvey_current)

# Check who hasn't finished the survey ------------------------------------

presurvey_with_participants <- presurvey_current %>%
    mutate(name_from_survey = full_name) %>%
    rename(email_from_survey = email) %>%
    full_join(participants %>%
                  mutate(name_from_list = full_name) %>%
                  rename(email_from_list = email))

participants_list <- presurvey_with_participants %>%
    select(full_name, name_from_survey, name_from_list, email = email_from_list)

# nrow(participants)
# nrow(participants_list)
View(participants_list)

# Get list of emails to remind to finish survey.
# participants_list %>%
#     filter(is.na(name_from_survey)) %>%
#     pull(email) %>%
#     clipr::write_clip()

# Check setup responses ---------------------------------------------------

# presurvey_current %>%
#     select(starts_with("check")) %>%
#     pull(check_setup_output) %>%
#     cat()

# presurvey_current %>%
#     select(starts_with("check")) %>%
#     pull(check_project_setup_output) %>%
#     write_lines("temp.txt")

# Save some details and the feedback --------------------------------------

prep_for_saving <- presurvey_current %>%
    select(-contains("email"), -contains("name"), -timestamp) %>%
    mutate(across(everything(), ~ str_remove_all(.x, '\\n|\\"'))) %>%
    select(where(~!all(is.na(.x))))

basic_overview <- prep_for_saving %>%
    select(starts_with("perceived"), gender_identity,
           research_position, city_work_in, previously_used_stat_programs) %>%
    pivot_longer(everything(), names_to = "Questions", values_to = "Responses") %>%
    count(Questions, Responses, name = "Count") %>%
    arrange(Questions, Responses, Count) %>%
    left_join(renaming_columns, by = c("Questions" = "new_column_names")) %>%
    select(-Questions, Questions = original_column_names) %>%
    relocate(Questions)

write_csv(basic_overview, here::here("data/2021-10-participant-overview.csv"))

precourse_feedback <- prep_for_saving %>%
    select(contains("feedback"), describe_problems, contains("course_expectations")) %>%
    pivot_longer(everything(), names_to = "Questions", values_to = "Responses") %>%
    arrange(Questions, Responses) %>%
    left_join(renaming_columns, by = c("Questions" = "new_column_names")) %>%
    na.omit() %>%
    select(-Questions, Questions = original_column_names) %>%
    relocate(Questions)

write_csv(precourse_feedback, here::here("feedback/2021-10-precourse.csv"))
