#' Trim file path for showing in book.
#'
#' @param data Data frame with `file_path_id` column.
#'
#' @return Tibble.
#'
trim_filepath_for_book <- function(data) {
    mutate(data, file_path_id = gsub(".*\\/data-raw", "data-raw", file_path_id))
}

