library(sparklyr)
library(dplyr)

is.spark_connection <- function(x)inherits(x, "spark_connection")

spark_read_prescriptions <- function(sc, file, name = "pres", memory = FALSE){
  assertthat::assert_that(is.spark_connection(sc))
  assertthat::assert_that(file.exists(file))

  columns <- list(
    "sha" = "character",
    "pct" = "character",
    "practice" = "character",
    "bnf_code" = "character",
    "bnf_name" = "character",
    "items" = "integer",
    "nic" = "double",
    "act_cost" = "double",
    "quantity" = "integer",
    "period" = "integer"
  )

  sc %>%
    sparklyr::spark_read_csv(
      name = name,
      path = file,
      columns = columns,
      header = FALSE,
      memory = memory,
      infer_schema = FALSE
    )
}


spark_read_postcodes <- function(sc, file, name = "postcodes", memory = FALSE){
  assertthat::assert_that(is.spark_connection(sc))
  assertthat::assert_that(file.exists(file))

  # pc <- read_csv(
  #   file.path(data_folder, "postcode-outcodes.csv"),
  #   col_types = "dcdd"
  # ) %>%
  #   filter(latitude != 0 & longitude != 0) %>%
  #   rename(outcode = "postcode")


  columns <- list(
    "id" = "character",
    "postcode" = "character",
    "latitude" = "numeric",
    "longitude" = "numeric"
  )

  sc %>%
    sparklyr::spark_read_csv(
      name = name,
      path = file,
      columns = columns,
      header = TRUE,
      memory = memory,
      infer_schema = FALSE
    ) %>%
    filter(latitude != 0 & longitude != 0) %>%
    rename(outcode = "postcode")

}

