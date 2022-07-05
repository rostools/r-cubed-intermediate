
extract_code_to_clipr <- function() {
    knitr::opts_chunk$set(purl = FALSE)
    temp_file <- fs::file_temp(ext = ".R")
    knitr::purl(
        input = here::here("content/00-pre-course.Rmd"),
        output = temp_file,
        documentation = 0L
    )

    readr::read_lines(temp_file) |>
        stringr::str_subset("^$", negate = TRUE) |>
        stringr::str_remove("^#+ ") |>
        clipr::write_clip()
}

# Use to paste below
extract_code_to_clipr()

# Code to create the course R Project -------------------------------------

learn_path <- fs::path("~", "Desktop", "LearnR3")
prodigenr::setup_project(learn_path)

to_proj <- '
prodigenr::setup_with_git()
usethis::use_blank_slate("project")
usethis::use_r("functions", open = FALSE)
r3::create_rmarkdown_doc()
usethis::use_data_raw("mmash")
usethis::use_git_ignore("data-raw/mmash-data.zip")
usethis::use_git_ignore("data-raw/mmash/")
fs::file_delete("TODO.md")
# Add and commit after downloading data.
gitcreds::gitcreds_set()
usethis::use_github(organization = "rostools")
'

readr::write_lines(to_proj, file = fs::path(learn_path, "TODO.R"), append = FALSE)

to_mmash_r <- '
library(here)

# Download
mmash_link <- "https://physionet.org/static/published-projects/mmash/multilevel-monitoring-of-activity-and-sleep-in-healthy-people-1.0.0.zip"
download.file(mmash_link, destfile = here("data-raw/mmash-data.zip"))

# Unzip
unzip(here("data-raw/mmash-data.zip"),
      exdir = here("data-raw"),
      junkpaths = TRUE)
unzip(here("data-raw/MMASH.zip"),
      exdir = here("data-raw"))

# Remove/tidy up left over files
library(fs)
file_delete(here(c("data-raw/MMASH.zip",
                   "data-raw/SHA256SUMS.txt",
                   "data-raw/LICENSE.txt")))
file_move(here("data-raw/DataPaper"), here("data-raw/mmash"))
'

readr::write_lines(to_mmash_r, file = fs::path(learn_path, "data-raw", "mmash.R"))
