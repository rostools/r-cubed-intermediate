
#' Include a hidden, but clickable, section of details that is for instructors.
#'
#' @param .text Text to include in the details to instructors.
#'
#' @return a text surrounded by the HTML tag `details`.
#'
details_for_instructors <- function(.text) {
    glue::glue("

    <details><summary><strong><em>For instructors: Click for details</em></strong></summary>
    <blockquote><p>
    {.text}
    </p></blockquote>
    </details>

    ")
}

#' Create a diagram of the overview of the course and workflow.
#'
#' @param section_num A number indicating which section to highlight. 0 = none.
#'
#' @return a DiagrammeR GraphVis object.
#'
diagram_overview <- function(section_num = 0) {
    stopifnot(section_num %in% 0:4)
    colour <- rep("black", times = 5)
    thickness <- rep(1, times = 5)
    if (section_num != 0) {
        colour[section_num] <- "red"
        thickness[section_num] <- 3
    }

    graphviz_template_text <- "
    digraph {
        # Styling
        graph [compound = true, nodesep = .1, ranksep = .1, rankdir = TB]
        node [shape = rectangle, style = filled, fixedsize = true,
              color = lightblue, fontsize = 14, width = 2.1]
        edge [fontsize = 14]

        # Nodes
        mmash_dir [label = 'data-raw/mmash/']
        mmash_dir_2 [label = 'data-raw/mmash/']
        mmash_dir_3 [label = 'data-raw/mmash/']
        mmash_r [label = 'data-raw/mmash.R']
        mmash_r_2 [label = 'data-raw/mmash.R']
        mmash_zip [label = 'data-raw/mmash-data.zip']
        rmd [label = 'doc/lesson.Rmd']
        rmd_2 [label = 'doc/lesson.Rmd']
        html [label = 'doc/lesson.html']
        fn_r [label = 'R/functions.R']
        fn_r_2 [label = 'R/functions.R']
        make_fn [label = 'Create function']
        mmash_rda [label = 'data/mmash.rda']
        mmash_rda_2 [label = 'data/mmash.rda']

        subgraph cluster1 {
            graph [label = 'Download\nraw data', fontsize = 14]
            color = ((colour[1]))
            penwidth = ((thickness[1]))
            mmash_r -> mmash_dir
            mmash_r -> mmash_zip [arrowhead = none]
            mmash_zip -> mmash_dir
        }

        subgraph cluster2 {
            graph [label = 'Workflow\n ', fontsize = 14]
            color = ((colour[2]))
            penwidth = ((thickness[2]))
            make_fn -> fn_r [label = '  cut & paste\ncommit']
            rmd -> make_fn [len = 2, label = '   ']
            make_fn -> rmd [len = 2, label = '   ']
            fn_r -> rmd [label = '   source']
            mmash_dir_2 -> rmd [label = '   import']
        }

        subgraph cluster3 {
            graph [label = 'Create\nfinal data', fontsize = 14]
            color = ((colour[3]))
            penwidth = ((thickness[3]))
            mmash_dir_3 -> mmash_rda
            fn_r_2 -> mmash_r_2 [label = '   source']
            mmash_r_2 -> mmash_dir_3 [arrowhead = none]
            mmash_r_2 -> mmash_rda
        }

        subgraph cluster4 {
            graph [label = 'Work with\nfinal data', fontsize = 14]
            color = ((colour[4]))
            penwidth = ((thickness[4]))
            mmash_rda_2 -> rmd_2 [label = '   import']
            rmd_2 -> html [label = '   knit']
        }

    }"
    graph_viz_text <- glue::glue(graphviz_template_text, .open = "((", .close = "))")
    DiagrammeR::grViz(graph_viz_text)
}


#' Source session R code for use when developing later sessions.
#'
#' @param rmd_file Chapter Rmd file.
#'
#' @return Nothing. Sources the Rmd file.
#'
source_session <- function(rmd_file) {
    tmp_r_file <- tempfile(fileext = ".R")
    knitr::purl(rmd_file, output = tmp_r_file,
                quiet = TRUE)
    source(tmp_r_file, verbose = FALSE, echo = FALSE,
           print. = FALSE)
    return(invisible(NULL))
}

#' Trim file path for showing in book.
#'
#' @param data Data frame with `file_path_id` column.
#'
#' @return Tibble.
#'
trim_filepath_for_book <- function(data) {
    mutate(data, file_path_id = gsub(".*\\/data-raw", "data-raw", file_path_id))
}
