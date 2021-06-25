
library(RefManageR)
library(knitr)
library(tidyverse)
library(htmltools)

knitr::opts_chunk$set(
    comment = "#>",
    collapse = TRUE,
    dpi = 72,
    fig.width = 6,
    fig.height = 6,
    fig.align = "center",
    out.width = "100%"
)

knitr::knit_hooks$set(solution = function(before) {
    if (before)
        "<details style='margin-bottom: 1rem'><summary><strong>Click for the (possible) solution.</strong> Click only if you are really struggling or you are out of time for the exercise.</summary><p>"
    else
        "</p></details>"
})

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

insert_video <- function(video_file) {
    htmltools::tags$video(
        htmltools::tags$source(
            src = video_file,
            type = "video/mp4"
        ),
        controls = NA,
        width = "100%"
    )
}
