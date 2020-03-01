read_nhs_pdpi <- function(x, col_types = "ccccciddii", col_names, ...){
  if (base::missing(col_names) || base::is.null(col_names)) {
    col_names <- readLines(x, n = 1) %>%
      strsplit(",") %>%
      extract2(1) %>%
      str_trim() %>%
      # names() %>%
      head(-1) %>%
      tolower() %>%
      gsub(" ", "_", .)
    col_names[10] <- "period"
  }

  suppressWarnings(
    # read_csv(x, skip = 1, n_max = n_max, col_names = col_names, ...)
    vroom::vroom(x, delim = ",", skip = 1, col_names = col_names, col_types = col_types, ...)
  )
}


read_nhs_addr <- function(x) {
  vroom::vroom(
    x,
    delim = ",",
    col_names = c(
      "period",
      "practice",
      "surgery",
      "address",
      "road",
      "town",
      "shire",
      "postcode"
    ),
    col_types = "dccccccc"
  )
}


read_nhs_chem_sub <- function(x) {
  vroom::vroom(
    x,
    delim = ",",
    col_names = c(
      "chem_sub",
      "name"
    ),
    col_types = "dc-"
  )
}
