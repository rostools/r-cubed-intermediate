
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
bib <- ReadBib(here::here("includes/refs.bib"))
knitr::opts_chunk$set(echo = FALSE)

# Customized theme
library(xaringanthemer)
style_mono_accent(
    base_color = "#0d47a1",
    base_font_size = "24px",
    code_font_size = "1.2em",
    header_font_google = google_font("Cabin"),
    text_font_google = google_font("KoHo"),
    code_font_google = google_font("Source Code Pro"),
    outfile = here::here("includes/xaringan-themer.css")
)
