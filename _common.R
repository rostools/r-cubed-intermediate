
library(RefManageR)
library(knitr)
library(htmltools)

# Remove any leftovers, just in case
delete_if_present <- function(path, type = c("dir", "file")) {
    fn_check <- switch(type, dir = fs::dir_exists, file = fs::file_exists)
    fn_delete <- switch(type, dir = fs::dir_delete, file = fs::file_delete)
    if (fn_check(path))
        fn_delete(path)
    return(invisible(NULL))
}
delete_if_present("data-raw/mmash", "dir")
delete_if_present("R/book-functions.R", "file")
fs::file_create("R/book-functions.R")

knitr::opts_chunk$set(
    comment = "#>",
    collapse = TRUE,
    dpi = 72,
    fig.width = 6,
    fig.height = 6,
    fig.align = "center",
    out.width = "100%"
)

knitr::knit_hooks$set(
    solution = function(before) {
        if (before)
            "<details style='margin-bottom: 1rem'><summary><strong>Click for the (possible) solution.</strong> Click only if you are really struggling or you are out of time for the exercise.</summary><p>"
        else
            "</p></details>"
    },
    instructor_details = function(before) {
        if (before)
            "<details style='margin-bottom: 1rem'><summary><strong><em>For instructors: Click for details.</em></strong></summary><blockquote><p>"

        else
            "</p></blockquote></details>"
    }
)

BibOptions(
    check.entries = FALSE,
    bib.style = "authoryear",
    cite.style = "authoryear",
    style = "markdown",
    super = TRUE
    # hyperlink = FALSE,
)

options(knitr.table.format = "html",
        dplyr.summarise.inform = FALSE,
        downlit.attached = c("snakecase", "vroom", "here", "prodigenr",
                             "fs", "dplyr", "tidyr"))

set.seed(12345)
