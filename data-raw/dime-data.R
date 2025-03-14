library(tidyverse)
library(here)
library(fs)

# Download
dime_url <- "https://zenodo.org/api/records/8268744/files-archive"
download.file(dime_url, destfile = here("data-raw/dime-data.zip"))

# Unzip
unzip(
  here("data-raw/dime-data.zip"),
  exdir = here("data-raw/dime-data/")
)
Sys.sleep(1)
unzip(
  here("data-raw/dime-data/CGM.zip"),
  exdir = here("data-raw/dime-data/cgm/")
)
Sys.sleep(1)
unzip(
  here("data-raw/dime-data/DIME_sleep_raw_data.zip"),
  exdir = here("data-raw/dime-data/sleep/")
)

# Remove this extra directory, has the same files
dir_delete(here("data-raw/dime-data/cgm/__MACOSX"))

# Processing the CGM data -------------------------------------------------

process_cgm <- function(path) {
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
    dplyr::rename(tidyselect::any_of(tibble::deframe(column_names)))
}

paths <- tibble(
  original = here("data-raw/dime-data/cgm") |>
    dir_ls(),
  renamed = original |>
    path_file() |>
    # This is the participant ID from the path.
    str_extract("^[:number:]+ ") |>
    str_replace(" ", ".csv") |>
    map_chr(\(path) here("data-raw/dime-data/cleaned/cgm", path))
)

dir_create(here("data-raw/dime-data/cleaned"))
dir_create(here("data-raw/dime-data/cleaned/cgm"))
pwalk(
  paths,
  \(original, renamed) {
    process_cgm(original) |>
      readr::write_csv(renamed)
  }
)

# Processing the participant data ----------------------------------------

readxl::read_excel(
  here::here("data-raw/dime-data/2023-08-21_Corrected_Participant_metadata.xlsx"),
  sheet = 1
) |>
  select(-starts_with("Biosamples")) |>
  mutate(across(contains("Day_"), lubridate::as_date)) |>
  pivot_longer(
    cols = contains("Day_"),
    names_sep = "_",
    names_to = c("day_order", "intervention"),
    values_to = "date"
  ) |>
  arrange(ID, date) |>
  mutate(
    intervention = case_when(
      intervention == "base" ~ "baseline",
      intervention == "Arm1" & FirstAllocation == "LOW" ~ "low bioactive diet",
      intervention == "Arm2" & FirstAllocation == "LOW" ~ "high bioactive diet",
      intervention == "Arm1" & FirstAllocation == "HIGH" ~ "high bioactive diet",
      intervention == "Arm2" & FirstAllocation == "HIGH" ~ "low bioactive diet"
    ),
    day_order = case_when(
      day_order == "FirstDay" ~ "start_date",
      day_order == "LastDay" ~ "end_date"
    ),
    gender = case_when(
      Sex == "M" ~ "man",
      Sex == "F" ~ "woman"
    )
  ) |>
  select(-FirstAllocation, -Sex) |>
  pivot_wider(
    names_from = day_order,
    values_from = date
  ) |>
  rename_with(snakecase::to_snake_case) |>
  relocate(gender, .before = age_years) |>
  write_csv(here("data-raw/dime-data/cleaned/participant_details.csv"))

# Processing the sleep data ----------------------------------------------

sleep_paths <- dir_ls(here("data-raw/dime-data/sleep"))

read_sleep_fitbit <- function(path) {
  empty_lines <- read_lines(path) |>
    str_detect("^,+$") |>
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
  read_csv(path,
    n_max = read_until,
    skip = skip_until,
    show_col_types = FALSE,
    col_names = FALSE
  )
}

sleep <- sleep_paths |>
  map(read_sleep_fitbit) |>
  list_rbind() |>
  select(ID = X2, Date = X4, Sleep_type = X5, Seconds = X6)

dir_create(here("data-raw/dime-data/cleaned/sleep"))
split(sleep, sleep$ID) |>
  iwalk(
    \(data, id) {
      data |>
        select(-ID) |>
        write_csv(here("data-raw/dime-data/cleaned/sleep", str_c(id, ".csv")))
    }
  )

withr::with_dir(here("data-raw/dime-data/cleaned/"), {
  zip::zip(
    zipfile = here("data/dime-data.zip"),
    files = dir_ls()
  )
})
