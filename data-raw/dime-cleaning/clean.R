library(tidyverse)
library(here)
library(fs)

read_cgm <- function(path) {
  cgm <- path |>
    readxl::read_excel(
      skip = 1,
      guess_max = 10000
    )

  # To eventually rename the columns back to the original names,
  # so that learners get exposure to using `snakecase`.
  column_names <- tibble(
    original = colnames(cgm),
    renamed = snakecase::to_snake_case(original)
  )

  cgm |>
    dplyr::rename_with(snakecase::to_snake_case) |>
    # There is `record_type` 1 or 6 that I don't know what it is. It has
    # "scan glucose", which I also don't know what that is. Seems to be not as
    # frequently sampled as the "historic glucose" is, which is about every
    # 20-30 seconds. So we'll go with having more data then less.
    dplyr::filter(record_type == 0) |>
    dplyr::select("device_timestamp", "historic_glucose_mmol_l") |>
    # Rename to the original variable names so the learners can practice renaming
    # to snake case.
    dplyr::rename(tidyselect::any_of(tibble::deframe(column_names)))
}


read_sleep_fitbit <- function(path) {
  # Find lines that are empty in order to start reading after two empty lines in
  # a row, which is where the data starts in the file.
  empty_lines <- readr::read_lines(path) |>
    stringr::str_detect("^,+$") |>
    # Get the line numbers of blank line.
    which()

  if (!(empty_lines[2] - empty_lines[1]) == 1) {
    rlang::abort("Check the lines, they need to be two empty lines in a row.")
  }

  # Skip until after the first two empty lines, plus one for the header.
  skip_until <- empty_lines[2] + 1
  # Read until next empty line, minus the ones to skip, the header, and the
  # empty line itself.
  read_until <- empty_lines[3] - skip_until - 2

  readr::read_csv(
    path,
    n_max = read_until,
    skip = skip_until,
    show_col_types = FALSE,
    col_names = FALSE
  )
}

read_participant_details <- function(path) {
  readxl::read_excel(path, sheet = 1) |>
    dplyr::select(-tidyselect::starts_with("Biosamples")) |>
    dplyr::mutate(dplyr::across(
      tidyselect::contains("Day_"),
      lubridate::as_date
    )) |>
    tidyr::pivot_longer(
      cols = dplyr::contains("Day_"),
      names_sep = "_",
      names_to = c("day_order", "intervention"),
      values_to = "date"
    ) |>
    dplyr::arrange(ID, date) |>
    dplyr::mutate(
      intervention = dplyr::case_when(
        intervention == "base" ~ "baseline",
        intervention == "Arm1" &
          FirstAllocation == "LOW" ~ "low bioactive diet",
        intervention == "Arm2" &
          FirstAllocation == "LOW" ~ "high bioactive diet",
        intervention == "Arm1" & FirstAllocation == "HIGH" ~
          "high bioactive diet",
        intervention == "Arm2" &
          FirstAllocation == "HIGH" ~ "low bioactive diet"
      ),
      day_order = dplyr::case_when(
        day_order == "FirstDay" ~ "start_date",
        day_order == "LastDay" ~ "end_date"
      ),
      gender = dplyr::case_when(
        Sex == "M" ~ "man",
        Sex == "F" ~ "woman"
      )
    ) |>
    dplyr::select(-FirstAllocation, -Sex) |>
    tidyr::pivot_wider(
      names_from = day_order,
      values_from = date
    ) |>
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::relocate(gender, .before = age_years)
}

# Processing the sleep data ----------------------------------------------

raw_path <- here("data-raw/dime-cleaning/raw/")
cleaned_path <- here("data-raw/dime-cleaning/cleaned/")

cgm_paths <- tibble(
  original = path(raw_path, "cgm") |>
    dir_ls(),
  renamed = original |>
    path_file() |>
    # This is the participant ID from the path.
    str_extract("^[:number:]+ ") |>
    str_replace(" ", ".csv") |>
    map_chr(\(path) path(cleaned_path, "cgm", path))
)

dir_create(cleaned_path)
dir_create(path(cleaned_path, "cgm"))

pwalk(
  cgm_paths,
  \(original, renamed) {
    read_cgm(original) |>
      readr::write_csv(renamed)
  }
)

sleep_paths <- dir_ls(path(raw_path, "sleep"))

sleep_data <- sleep_paths |>
  map(read_sleep_fitbit) |>
  list_rbind() |>
  select(ID = X2, Date = X4, Sleep_type = X5, Seconds = X6)

dir_create(path(cleaned_path, "sleep"))
split(sleep_data, sleep_data$ID) |>
  iwalk(
    \(data, id) {
      data |>
        select(-ID) |>
        write_csv(path(
          cleaned_path,
          "sleep",
          str_c(id, ".csv")
        ))
    }
  )

path(raw_path, "2023-08-21_Corrected_Participant_metadata.xlsx") |>
  read_participant_details() |>
  readr::write_csv(path(
    cleaned_path,
    "participant_details.csv"
  ))

withr::with_dir(here("data-raw/dime-cleaning/"), {
  zip::zip(
    zipfile = path("dime.zip"),
    files = dir_ls(path("cleaned"), recurse = TRUE)
  )
})
