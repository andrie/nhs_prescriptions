library(readr)
library(magrittr)
library(pins)

pin_from_bucket <- function(
  filename,
  prefix = c("practice-level", "ONS-postcodes"),
  pin_name = filename
) {
  prefix <-  match.arg(prefix)
  base_url <- "https://nhs-prescription-data.s3-us-west-2.amazonaws.com"
  bucket_url <- paste(base_url, prefix, filename, sep = "/")
  pins::pin(bucket_url, name = filename)
  filename
}


pin_from_bucket("t201901addr_bnft.csv")
pin_from_bucket("t201901pdpi_bnft.csv")
pin_from_bucket("t201901chem_subs.csv")
pin_from_bucket("postcode-outcodes.csv", prefix = "ONS-postcodes")


# pin_get("t201901addr_bnft.csv") %>%
#   read_csv(n_max = 10)
#
# pin_get("t201901pdpi_bnft.csv") %>%
#   read_csv(n_max = 10)
#
#
# pin_get("t201901chem_subs.csv") %>%
#   read_csv(n_max = 10)
#
# pin_get("postcode-outcodes.csv") %>%
#   read_csv(n_max = 10)
