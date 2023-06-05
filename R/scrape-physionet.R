library(rvest)
library(polite)
library(rmarkdown)
library(stringr)

mmash_page <- bow("https://physionet.org/content/mmash/1.0.0/")

mmash_html <- mmash_page %>%
  scrape() %>%
  html_node(".col-md-8")

temp_html <- tempfile(fileext = ".html")
write_html(mmash_html, temp_html)

temp_md <- tempfile(fileext = ".md")
pandoc_convert(temp_html, to = "markdown_strict", output = temp_md)

readLines(temp_md)[-(8:76)] %>%
  str_remove("\\\\") %>%
  writeLines(temp_md)

render(
  input = temp_md,
  output_file = here::here("resources/mmash-page.html"),
  output_format = html_document(
    pandoc_args = c("--metadata", "title=MMASH Page")
  )
)
