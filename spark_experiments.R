library(arrow)
library(sparklyr)
library(dplyr)

sc <- spark_connect(master = "local")

data_folder <- "C:/Users/apdev/Downloads/NHS_prescription_data/Nov_2018"

# sed

# sed 's/, *\r*$//' 'C:/Users/apdev/Downloads/NHS_prescription_data/Nov_2018/T201811PDPI BNFT.CSV' > 'T201811PDPI_BNFT.csv'

# sed -e '1d' -e 's/, *\r*$//' 'C:/Users/apdev/Downloads/NHS_prescription_data/Nov_2018/T201811PDPI BNFT.CSV' > T201811PDPI_BNFT.csv


source("R/spark_read_prescriptions.R")

pc <-
  sc %>%
  spark_read_postcodes(
  file.path(data_folder, "postcode-outcodes.csv")
)
pc

source("R/plot_postcode.R")
pc %>%
  plot_postcode(title = "UK postcodes (outcode level)")

source("R/plot_postcode.R")
pc %>%
  plot_postcode(title = "UK postcodes (outcode level)", hex = TRUE)



system.time({
pres <- sc %>%
  spark_read_prescriptions(file = "T201811PDPI_BNFT.csv")
})

sc %>% src_tbls()
pres %>% head(10)


system.time({
  pres %>%
    group_by(period, bnf_name) %>%
    summarise(
      items = sum(items, na.rm = TRUE),
      quantity = sum(quantity, na.rm = TRUE),
      nic = sum(nic, na.rm = TRUE),
      act_cost = sum(act_cost, na.rm = TRUE)
    ) %>%
    arrange(desc(act_cost)) %>%
    print()
})

## without arrow: 20.5 seconds
## with arrow: 16.3 seconds

pres %>%
  group_by(period, bnf_code) %>%
  summarise(
    items = sum(items, na.rm = TRUE),
    quantity = sum(quantity, na.rm = TRUE),
    nic = sum(nic, na.rm = TRUE),
    act_cost = sum(act_cost, na.rm = TRUE)
  ) %>%
  arrange(desc(act_cost))

pres %>%
  group_by(period, practice) %>%
  summarise(
    items = sum(items, na.rm = TRUE),
    quantity = sum(quantity, na.rm = TRUE),
    nic = sum(nic, na.rm = TRUE),
    act_cost = sum(act_cost, na.rm = TRUE)
  ) %>%
  arrange(desc(act_cost))
