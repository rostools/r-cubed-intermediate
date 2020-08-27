library(rvest)
library(polite)
library(rmarkdown)

mmash_page <- bow("https://physionet.org/content/mmash/1.0.0/")

mmash_html <- mmash_page %>%
    scrape() %>%
    html_node(".col-md-8")

mmash_html %>%
    html_nodes(xpath = "//div[not(contains(@class,'alert'))]")

temp_html <- tempfile(fileext = ".html")
write_html(mmash_html, temp_html)

temp_md <- tempfile(fileext = ".md")
pandoc_convert(temp_html, to = "markdown_strict", output = temp_md)

render(input = temp_md, output_file = here::here("resources/mmash-page.html"),
       output_format = html_document(pandoc_args = c("--metadata", "title=MMASH Page")))

