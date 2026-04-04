library(tidyverse)
library(here)
library(fs)
library(furrr)
library(duckplyr)
library(arrow)

# Functions --------------------------------------------------------------

#' Create a datetime rows from the first two lines of the file
#'
#' The first line of the file must be the start date and the second line is the
#' sampling rate in Hertz.
#'
#' @param file The file that has the first line/row as the start date and the
#'   second row is the sampling rate.
#' @param n The number of rows to generate the datetime column for.
#'
#' @returns The datetime column to be added to the data frame.
#'
create_datetime_rows <- function(file, n) {
  start_datetime <- file |>
    readr::read_csv(col_names = FALSE, n_max = 1, show_col_types = FALSE) |>
    dplyr::pull(X1) |>
    lubridate::as_datetime()

  collection_frequency_seconds <- file |>
    readr::read_csv(
      col_names = FALSE,
      n_max = 1,
      skip = 1,
      show_col_types = FALSE
    ) |>
    # Convert to seconds as it is in hertz.
    dplyr::mutate(X1 = 1 / X1) |>
    dplyr::pull(X1)

  seq(
    from = start_datetime,
    by = collection_frequency_seconds,
    length.out = n
  ) |>
    # Round to the nearest millisecond to avoid issues with floating point
    # precision.
    lubridate::round_date(unit = ".001s")
}

#' Add a datetime column to the data frame
#'
#' @param data The data to add the column to.
#' @param file The file where the data was loaded from.
#'
#' @returns A data frame with the datetime column added.
#'
add_datetime_column <- function(data, file) {
  data |>
    dplyr::mutate(
      collection_datetime = file |>
        create_datetime_rows(n = dplyr::n()),
      .before = tidyselect::everything()
    )
}

#' Read the data into DuckDB and add the variable name from the file name
#'
#' DuckDB is a tool/package to process data very quickly.
#'
#' @param file The file to read from.
#'
#' @returns A data frame.
#'
read_into_duckdb <- function(file) {
  # Get the variable name from the file name.
  variable_name <- file |>
    fs::path_file() |>
    fs::path_ext_remove()

  file |>
    readr::read_csv(col_names = FALSE, skip = 2, show_col_types = FALSE) |>
    dplyr::as_tibble() |>
    # To make things faster.
    duckplyr::as_duckdb_tibble() |>
    # Inject the variable from above.
    dplyr::rename({{ variable_name }} := X1)
}

#' Summarise the data by a specific time unit
#'
#' @param data The data frame to summarise.
#' @param unit The time unit to summarise by.
#'
#' @returns A data frame.
#'
summarise_by_time <- function(data, unit = "minute") {
  data |>
    dplyr::mutate(
      collection_datetime = collection_datetime |>
        lubridate::round_date(unit = unit)
    ) |>
    dplyr::summarise(
      dplyr::across(
        dplyr::where(is.numeric),
        \(x) mean(x, na.rm = TRUE)
      ),
      .by = "collection_datetime"
    )
}

#' Convert the raw path to point to the clean folder and use gzip format
#'
#' @param path The path to the raw file.
#'
#' @returns The path to the cleaned file.
#'
replace_raw_to_cleaned <- function(path) {
  path |>
    stringr::str_replace("nurses-stress/raw/", "nurses-stress/cleaned/") |>
    stringr::str_replace("\\.csv$", ".csv.gz")
}

#' Write the (non-IBI) data, summarised by second, to a new cleaned file
#'
#' @param path The path to the raw file.
#'
#' @returns Side effect of writing the cleaned data to disk.
#'
write_by_second <- function(path) {
  new_path <- replace_raw_to_cleaned(path)
  fs::dir_create(fs::path_dir(new_path))

  # Return nothing if file is empty.
  if (fs::file_info(path)$size == 0) {
    return(NULL)
  }

  path |>
    read_into_duckdb() |>
    add_datetime_column(path) |>
    summarise_by_time("second") |>
    # Intentionally use PascalCase so they can fix to snake_case
    dplyr::rename(CollectionDatetime = collection_datetime) |>
    readr::write_csv(new_path)
}

#' Write the IBI data, summarised by second, to a new cleaned file
#'
#' Some of the IBI files have duplicated rows at the start, so I had to skip
#' those rows when reading in the data. I had to manually inspect the data
#' file to determine the number of rows to skip.
#'
#' @param path The path to the raw file.
#'
#' @returns Side effect of writing the cleaned data to disk.
#'
write_ibi_by_second <- function(path) {
  new_path <- replace_raw_to_cleaned(path)
  fs::dir_create(fs::path_dir(new_path))

  # Return nothing if file is empty.
  if (fs::file_info(path)$size == 0) {
    return(NULL)
  }

  ibi_start_time_seconds <- path |>
    readr::read_csv(
      n_max = 1,
      col_names = FALSE,
      show_col_types = FALSE
    ) |>
    dplyr::pull(X1)

  # Read in specific files with different skip values to remove duplicated rows.
  if (stringr::str_detect(path, "BG_1607218219/IBI.csv")) {
    # This file seems to duplicate the first 91 (plus header) rows, so skip them.
    data <- path |>
      readr::read_csv(skip = 92, col_names = FALSE, show_col_types = FALSE)
  } else if (stringr::str_detect(path, "F5_1594920460/IBI.csv")) {
    # This file seems to duplicate the first 31 (plus header) rows, so skip them.
    data <- path |>
      readr::read_csv(skip = 32, col_names = FALSE, show_col_types = FALSE)
  } else {
    data <- path |>
      readr::read_csv(skip = 1, col_names = FALSE, show_col_types = FALSE)
  }

  data |>
    dplyr::rename(time_since_start = X1, IBI = X2) |>
    dplyr::as_tibble() |>
    # To make things faster.
    duckplyr::as_duckdb_tibble() |>
    dplyr::mutate(
      collection_datetime = lubridate::as_datetime(
        ibi_start_time_seconds + time_since_start
      )
    ) |>
    dplyr::select(-time_since_start) |>
    summarise_by_time("second") |>
    # Intentionally use PascalCase so they can fix to snake_case
    dplyr::select(CollectionDatetime = collection_datetime, IBI) |>
    readr::write_csv(new_path)
}

# Processing, cleaning, and writing --------------------------------------

raw_path <- here("data-raw/nurses-stress/raw/")
survey_path <- here(raw_path, "survey-results.csv")
cleaned_path <- here("data-raw/nurses-stress/cleaned/")
tar_path <- here("data-raw/nurses-stress/cleaned-nurses-stress.tar")

# Start from scratch by deleting all files in the cleaned path.
if (dir_exists(cleaned_path)) {
  dir_ls(cleaned_path, type = "file", recurse = TRUE) |>
    walk(file_delete)
  dir_delete(cleaned_path)
}
dir_create(cleaned_path)

# List all files that aren't IBI (which need different processing).
path_data <- dir_ls(
  here(raw_path, "stress"),
  recurse = TRUE,
  regexp = ".*(BVP|TEMP|HR|EDA)\\.csv$"
)

path_ibi <- dir_ls(
  here(raw_path, "stress"),
  recurse = TRUE,
  regexp = ".*IBI\\.csv$"
)

# Process and write to file using parallel processing.
future::plan(future::multicore)
path_data |>
  future_walk(write_by_second)

path_ibi |>
  future_walk(write_ibi_by_second)

# Need to convert to CSV from inside Excel
survey_data <- here(raw_path, "SurveyResults.csv") |>
  read_csv(
    na = "na",
    show_col_types = FALSE
  ) |>
  write_csv(replace_raw_to_cleaned(survey_path))

# Convert to tar as archive only, since each CSV is already in gzip format.
withr::with_dir(cleaned_path, {
  tar(
    tar_path,
    compression = "none"
  )
})
