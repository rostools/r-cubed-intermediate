
options(htmltools.dir.version = FALSE)

# Insert references
library(RefManageR)
BibOptions(
    match.date = "year.only",
    check.entries = "warn",
    bib.style = "numeric",
    cite.style = "numeric",
    style = "markdown",
    max.names = 2,
    super = FALSE
    # hyperlink = FALSE,
)
bib <- ReadBib(here::here("resources/refs.bib"))
knitr::opts_chunk$set(echo = FALSE)

# Customized theme
library(xaringanthemer)
style_mono_accent(
    base_color = "#2a2e44",
    header_font_google = google_font("Fira Sans"),
    text_font_google = google_font("Crimson Text"),
    code_font_google = google_font("Source Code Pro"),
    outfile = here::here("includes/xaringan-themer.css")
)
