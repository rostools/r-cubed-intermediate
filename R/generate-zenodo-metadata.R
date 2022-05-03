library(desc)
library(tidyverse)
library(zen4R)
library(gert)

stop("To prevent accidental sourcing.")

course_date <- "2021-10"
repo_version <- str_c("v", str_replace(course_date, "-", "."))

# Tag and release on GitLab -----------------------------------------------

version_tag <- git_tag_create(
    name = repo_version,
    message = "Material used for the October 2021 course."
)

git_push()
git_tag_push(repo_version)
if (interactive()) browseURL("https://gitlab.com/rostools/r-cubed-intermediate/-/releases/new")

# Update Zenodo -----------------------------------------------------------

authors_df <- read_csv(
    here::here("data/_people.csv"),
    col_types = cols(
        full_name = col_character(),
        primary_affiliation = col_character(),
        orcid = col_character(),
        instructor_role = col_logical(),
        contributor_role = col_logical(),
        helper_role = col_logical(),
        start_date = col_date(format = ""),
        end_date = col_date(format = "")
    )) %>%
    filter(contributor_role) %>%
    mutate(
        family = word(full_name, -1),
        given = str_remove(full_name, glue::glue(" {family}")),
        name = glue::glue("{family}, {given}")
    ) %>%
    transmute(
        name = glue::glue("{family}, {given}"),
        affiliation = primary_affiliation,
        orcid = orcid
    )

lesson_title <- desc_get_field("Title") %>%
    str_remove_all("\"") %>%
    str_remove_all("\\n") %>%
    str_replace_all(" +", " ") %>%
    str_replace(":", " -")

description_content <- desc_get_field("Description") %>%
    str_remove_all("\\n") %>%
    str_replace_all(" +", " ")

tag_archive_file <- str_c("r-cubed-intermediate-", repo_version, ".zip")
git_archive_zip(tag_archive_file)

zenodo <- ZenodoManager$new(
    url = "https://zenodo.org/api",
    logger = "INFO",
    token = askpass::askpass()
)

update_record <- zenodo$getDepositionById("4061900")
update_record <- zenodo$editRecord(update_record$id)

# Only if new authors have been added.
# TODO: Write filter to keep only new authors from Zenodo record.
# pwalk(authors_df, update_record$addCreator)
update_record$removeRelatedIdentifier(
    "isIdenticalTo",
    "https://gitlab.com/rostools/r-cubed/-/tags/v3.0"
)
update_record$addRelatedIdentifier(
    "isIdenticalTo",
    str_c("https://gitlab.com/rostools/r-cubed/-/tags/", repo_version)
)

update_record$setVersion(repo_version)
deposited_record <- zenodo$depositRecordVersion(update_record, files = tag_archive_file)
fs::file_delete(tag_archive_file)
