library(aws.s3)
library(dplyr)
library(purrr)
library(stringr)
# library(magrittr)

# Sys.setenv(
#   # "AWS_ACCESS_KEY_ID" = "mykey",
#   # "AWS_SECRET_ACCESS_KEY" = "mysecretkey",
#   "AWS_DEFAULT_REGION" = "us-west-2",
#   "AWS_SESSION_TOKEN" = "mytoken"
# )


bucketlist()
df <-
  get_bucket_df("nhs-prescription-data") %>%
  as_tibble()

str_match(df$Key, "PDPI")

df %>%
  mutate(
    pdpi = str_match(Key, "PDPI BNFT") %>% is.na() %>% not(),
    Size = as.numeric(Size)
  ) %>%
  filter(pdpi) %>%
  select(Key, Size) %>%
  summarise(
    n = n(),
    Size = sum(Size)
  )
