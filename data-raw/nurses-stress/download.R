library(purrr)
library(here)
library(fs)

# Download
nurses_stress_zip <- "https://zenodo.org/api/records/5514277/files-archive"
download.file(
  nurses_stress_zip,
  destfile = here("data-raw/nurses-stress/raw.zip")
)

raw_path <- here("data-raw/nurses-stress/raw/")
# Unzip
zip::unzip(
  here("data-raw/nurses-stress/raw.zip"),
  exdir = raw_path
)
# Sleep for a bit to avoid when unzip is too slow and the next unzip command
# runs before the first one finishes, which causes an error.
Sys.sleep(1)
zip::unzip(
  here("data-raw/nurses-stress/raw/Stress_dataset.zip"),
  exdir = fs::path(raw_path, "stress/")
)
Sys.sleep(1)

# Inside the sub-folders are other zip files that needs to be unzipped.
unzip_stress_file <- function(file) {
  zip_output_folder <- fs::path_ext_remove(file)
  zip::unzip(file, exdir = zip_output_folder)
  zip_output_folder
}

# This unzips all zip files recursively.
dir_ls(here(raw_path, "stress"), recurse = TRUE, glob = "*.zip") |>
  walk(unzip_stress_file)
