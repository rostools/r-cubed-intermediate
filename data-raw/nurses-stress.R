library(tidyverse)
library(here)
library(fs)
library(furrr)
library(duckplyr)

# Download
# nurses_stress_zip <- "https://zenodo.org/api/records/5514277/files-archive"
# download.file(nurses_stress_zip, destfile = here("data-raw/nurses-stress.zip"))

raw_path <- here("data-raw/nurses-stress/raw/")
# Unzip
zip::unzip(
  here("data-raw/nurses-stress.zip"),
  exdir = raw_path
)
Sys.sleep(1)
zip::unzip(
  here("data-raw/nurses-stress/raw/Stress_dataset.zip"),
  exdir = fs::path(raw_path, "stress/")
)
Sys.sleep(1)

unzip_stress_file <- function(file) {
  zip_output_folder <- fs::path_ext_remove(file)
  zip::unzip(file, exdir = zip_output_folder)
  zip_output_folder
}

dir_ls(here(raw_path, "stress"), recurse = TRUE, glob = "*.zip") |>
  walk(unzip_stress_file)

add_datetime_column <- function(file, n) {
  collection_frequency_seconds <- file |>
    read_csv(col_names = FALSE, n_max = 1, skip = 1, show_col_types = FALSE) |>
    # Convert to seconds as it is in hertz.
    mutate(X1 = 1 / X1) |>
    pull(X1)

  start_datetime <- file |>
    read_csv(col_names = FALSE, n_max = 1, show_col_types = FALSE) |>
    mutate(across(where(is.numeric), as_datetime)) |>
    pull(X1)

  seq(
    from = start_datetime,
    by = collection_frequency_seconds,
    length.out = n
  ) |>
    round_date() |>
    as.character()
}

dir_ls(here(raw_path, "stress"), recurse = TRUE, regexp = ".*(BVP|TEMP|HR)\\.csv$") |>
  future_walk(\(file) {
    variable <- file |>
      path_file() |>
      path_ext_remove()
    file |>
      read_csv(col_names = FALSE, skip = 2, show_col_types = FALSE) |>
      # Inject the variable from above.
      rename({{ variable }} := X1) |>
      mutate(
        collection_datetime = file |>
          add_datetime_column(n = n()),
        .before = everything()
      ) |>
      as_duckdb_tibble() |>
      group_by(collection_datetime) |>
      summarise(across(everything(), \(x) mean(x, na.rm = TRUE)), .groups = "drop") |>
      mutate(collection_datetime = as_datetime(collection_datetime)) |>
      arrow::write_parquet(path_ext_set(file, "parquet"))
  })

survey_path <- here(raw_path, "survey-results.csv")
# Need to convert to CSV from inside Excel
here(raw_path, "SurveyResults.csv") |>
  read_csv(
    na = "na"
  ) |>
  write_csv(survey_path)

zip::zip(
  here("data-raw/nurses-stress/nurses-stress.zip"),
  c(survey_path, dir_ls(raw_path, recurse = TRUE, glob = "*.parquet")) |>
    path_rel(raw_path),
  root = raw_path
)
