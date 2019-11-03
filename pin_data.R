library(readr)
library(magrittr)
library(pins)

pin_from_bucket <- function(filename, pin_name = filename) {
  base_url <- "https://nhs-prescription-data.s3-us-west-2.amazonaws.com/practice-level/"
  bucket_url <- paste0(base_url, filename)
  pins::pin(bucket_url, name = filename)
  filename
}


pin_from_bucket("t201901addr_bnft.csv")
pin_from_bucket("t201901pdpi_bnft.csv")
pin_from_bucket("t201901chem_subs.csv")

pin_get("t201901addr_bnft.csv") %>%
  read_csv(n_max = 10)

pin_get("t201901pdpi_bnft.csv") %>%
  read_csv(n_max = 10)


pin_get("t201901chem_subs.csv") %>%
  read_csv(n_max = 10)
