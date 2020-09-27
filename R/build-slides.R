
rmarkdown::render(
    input = here::here("slides/introduction.Rmd"),
    knit_root_dir = here::here("."),
    quiet = TRUE
)

rmarkdown::render(
    input = here::here("slides/next-steps.Rmd"),
    knit_root_dir = here::here("."),
    quiet = TRUE
)
