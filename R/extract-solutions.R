
extract_solution_chunks <- function(rmd_file) {
    # readLines(rmd_file) %>%
    #     commonmark::markdown_xml() %>%
    #     xml2::read_xml() %>%
    #     xml2::xml_find_all("//*[@info[contains(., 'solution')]]")
    readLines(rmd_file) %>%
        commonmark::markdown_xml() %>%
        xml2::read_xml()
    # %>%
    #     xml2::xml_find_all("")
        # xml2::xml_find_all("//*[@info[contains(., 'solution')]]/preceding::*[heading]")
}

extract_solution_chunks("03-dry.Rmd") %>%
    xml2::xml_find_all("//*[@level = '2']/*[contains(text(), 'Exercise')] | //*[@info[contains(., 'solution')]]") %>%
    xml2::xml_text()

readLines("03-dry.Rmd") %>%
    commonmark::markdown_html() %>%
    xml2::read_html() %>%
    rvest::html_nodes(xpath = "//code[contains(@class, 'language-{r')]") %>%
    rvest::html_text()
    rvest::html_nodes(xpath = "//h2[contains(text(), 'Exercise')] | //code[contains(., 'solution')]]"")

rvest::read_html


# knitr::purl("03-dry.Rmd")
