source(here::here("R/fetch-pre-survey.R"))
library(tidyverse)

stop("To prevent accidentally sourcing.")

# Create team names -------------------------------------------------------

# Create random team names
set.seed(534)
team_prefix <- tibble(adjective = praise::praise_parts$adjective) %>%
    filter(nchar(adjective) <= 9) %>%
    pull(adjective) %>%
    str_to_sentence() %>%
    sample()

team_suffix <- tidytext::parts_of_speech %>%
    filter(str_detect(pos, "^Noun$"),
           nchar(word) <= 9,
           !str_detect(word, "\\d|/|-")) %>%
    sample_n(length(team_prefix)) %>%
    pull(word) %>%
    str_to_sentence()

team_names <- glue::glue("Team{team_prefix}{team_suffix}") %>%
    as.character()

# Number of groups would be = participants / persons per group
# 30 / 4
# So about 8 groups
team_names_final <- team_names[c(11, 12, 20, 21, 27, 32, 35, 67)]

# Put participants into teams ---------------------------------------------

fix_skill_levels <- function(x) {
    all_levels <- c(
        "Beginner",
        "Beginner-Intermediate",
        "Intermediate",
        "Intermediate-Advanced",
        "Advanced"
    )
    current_levels <- unique(na.omit(x))
    fct_relevel(x, intersect(all_levels, current_levels))
}

teams_prep <- presurvey_current %>%
    select(full_name, matches("^perceived")) %>%
    mutate(across(-full_name, ~as.numeric(fix_skill_levels(.x)) > 1)) %>%
    rowwise() %>%
    mutate(perceived_skill_score = sum(c_across(starts_with("perceived")))) %>%
    select(full_name, perceived_skill_score)

# Randomly assign participants to groups, weighted by their
# perceived skill.
library(randomizr)

set.seed(97)
teams_assigned <- teams_prep %>%
    mutate(team = (perceived_skill_score >= 4) %>%
               block_ra(conditions = team_names_final) %>%
               as.character()) %>%
    arrange(team, perceived_skill_score)
count(teams_assigned, team)
View(teams_assigned)

# Manually change if need be.
# teams_assigned <- edit(teams_assigned)

# Format teams and names so its easier to put name tags when physically
# putting groups together.
format_teams <- function(data) {
    append(
        paste0("# ", unique(data$team), "\n"),
        data$full_name
    ) %>%
        str_c(collapse = "\n- ")
}

gh_teams_assigned %>%
    select(team, full_name) %>%
    group_split(team) %>%
    map_chr(format_teams) %>%
    str_c(collapse = "\n\n") %>%
    clipr::write_clip()

# Send invites to Slack ---------------------------------------------------

presurvey_current %>%
    pull(email) %>%
    str_c(collapse = ", ") %>%
    clipr::write_clip()

# Assigning instructors to groups -----------------------------------------
# Don't need to do this for this course at this point in time.
# instructors <- c("")

# set.seed(156)
# instructor_assigned_teams <- tibble(
#     teams = team_names_final,
#     primary = sample(rep(instructors, times = 2), 6),
#     secondary = sample(rep(instructors, times = 2), 6)
# )
# instructor_assigned_teams
#
# instructor_assigned_teams %>%
#     rename_with(str_to_sentence) %>%
#     knitr::kable() %>%
#     clipr::write_clip()
