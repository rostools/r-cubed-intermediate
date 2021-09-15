#!/usr/bin/env Rscript

message("Starting to build the website.")
library(magrittr)
bookdown::clean_book(TRUE)
# Create the course book
output <- bookdown::render_book('index.Rmd', 'bookdown::bs4_book', quiet = TRUE)

# Create necessary folders in public
fs::dir_create(here::here("public", c("resources", "slides")))

slide_css <- fs::dir_ls("slides", glob = "*.css")
fs::file_copy(slide_css, fs::path("public/", slide_css), overwrite = TRUE)

warnings()

message("Finished building it.")
