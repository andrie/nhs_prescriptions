# library(readr)
# library(magrittr)
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



