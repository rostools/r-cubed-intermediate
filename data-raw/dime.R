library(here)
library(tidyverse)

#' Read a CSV file and use snake case.
#'
#' @param path Path to CSV file.
#'
#' @returns Tibble.
read <- function(path) {
  readr::read_csv(
    path,
    show_col_types = FALSE,
    name_repair = snakecase::to_snake_case
  )
}

#' Read all CSV files in a directory and combine into one tibble.
#'
#' @param path Path to directory containing CSV files.
#'
#' @returns Tibble.
read_all <- function(path) {
  fs::dir_ls(path, glob = "*.csv") |>
    purrr::map(read) |>
    purrr::list_rbind(names_to = "path")
}

#' Get the participant ID from the file path and add it as a column.
#'
#' @param data The tibble with a file path column.
#'
#' @returns Tibble with participant ID column.
get_participant_id <- function(data) {
  data |>
    dplyr::mutate(
      id = path |>
        fs::path_file() |>
        fs::path_ext_remove() |>
        as.numeric(),
      .before = tidyselect::everything()
    ) |>
    dplyr::select(-path)
}

#' Tidy up CGM data, like renaming columns, making a date column, and summarise by day.
#'
#' @param data The tibble with CGM data.
#'
#' @returns Tibble with tidy CGM data.
tidy_cgm <- function(data) {
  data |>
    dplyr::rename(
      datetime = device_timestamp,
      glucose = historic_glucose_mmol_l
    ) |>
    dplyr::mutate(
      date = lubridate::as_date(datetime),
      .after = id
    ) |>
    dplyr::select(-datetime) |>
    dplyr::summarise(
      glucose = mean(glucose),
      .by = c(id, date)
    )
}

#' Tidy up sleep data, like renaming columns, making a date column, and pivoting wider.
#'
#' @param data The tibble with sleep data.
#'
#' @returns Tibble with tidy sleep data.
tidy_sleep <- function(data) {
  data |>
    dplyr::rename(datetime = date) |>
    dplyr::mutate(
      sleep_type = dplyr::case_when(
        sleep_type == "wake" ~ "awake",
        TRUE ~ sleep_type
      )
    ) |>
    dplyr::mutate(
      date = lubridate::as_date(datetime),
      .after = id
    ) |>
    dplyr::select(-datetime) |>
    dplyr::summarise(
      seconds = sum(seconds),
      .by = c(id, date, sleep_type)
    ) |>
    tidyr::pivot_wider(
      names_from = sleep_type,
      values_from = seconds
    )
}

#' Tidy up participant details data, like pivoting longer and completing dates.
#'
#' @param data The tibble with participant details data.
#'
#' @returns Tibble with tidy participant details data.
tidy_participant_details <- function(data) {
  data |>
    tidyr::pivot_longer(
      c(start_date, end_date),
      names_to = NULL,
      values_to = "date"
    ) |>
    dplyr::group_by(dplyr::pick(-date)) |>
    tidyr::complete(
      date = seq(
        min(date),
        max(date),
        by = "1 day"
      )
    ) |>
    dplyr::ungroup()
}

# This is the path to the data used within this repository,
# it will be different from yours.
dime_raw <- here("data-raw/dime-cleaning/cleaned/")

cgm <- here(dime_raw, "cgm/") |>
  read_all() |>
  get_participant_id() |>
  tidy_cgm()

sleep <- here(dime_raw, "sleep/") |>
  read_all() |>
  get_participant_id() |>
  tidy_sleep()

participant_details <- here(dime_raw, "participant_details.csv") |>
  read() |>
  tidy_participant_details()

final <- participant_details |>
  dplyr::full_join(cgm) |>
  dplyr::full_join(sleep)

# View(final)
# write_csv(final, here("data/cleaned-dime.csv"))
