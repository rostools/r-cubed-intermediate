#!/usr/bin/env Rscript

message("Starting to build the website.")
library(magrittr)
bookdown::clean_book(TRUE)
# Create the course book
output <- bookdown::render_book('index.Rmd', 'bookdown::bs4_book', quiet = TRUE)

# Create necessary folders in public
fs::dir_create(here::here("public", c("resources", "slides", "includes")))

slide_css <- fs::dir_ls("includes", glob = "*.css")
fs::file_copy(slide_css, fs::path("public/", slide_css), overwrite = TRUE)

html_files <- fs::dir_ls("public", glob = "*.html")

html_files %>%
    purrr::map(readr::read_lines) %>%
    purrr::map(~ {
        stringr::str_replace(., "fa-github", "fa-gitlab") %>%
            stringr::str_replace("rostools/r-cubed-intermediate/(blob|edit)/master",
                                 "rostools/r-cubed-intermediate/\\1/main")
    }) %>%
    purrr::iwalk(readr::write_lines)

warnings()

message("Finished building it.")
