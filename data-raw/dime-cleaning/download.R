library(here)
library(fs)

# Download
dime_url <- "https://zenodo.org/api/records/8268744/files-archive"
download.file(dime_url, destfile = here("data-raw/dime-cleaning/raw.zip"))

# Unzip
unzip(
  here("data-raw/dime-cleaning/raw.zip"),
  exdir = here("data-raw/dime-cleaning/raw/")
)
Sys.sleep(1)
unzip(
  here("data-raw/dime-cleaning/raw/CGM.zip"),
  exdir = here("data-raw/dime-cleaning/raw/cgm/")
)
Sys.sleep(1)
unzip(
  here("data-raw/dime-cleaning/raw/DIME_sleep_raw_data.zip"),
  exdir = here("data-raw/dime-cleaning/raw/sleep/")
)

# Remove this extra directory, has the same files
dir_delete(here("data-raw/dime-cleaning/raw/cgm/__MACOSX"))
