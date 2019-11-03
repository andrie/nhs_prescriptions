library(arrow)
library(sparklyr)
library(dplyr)
library(pins)

sc <- spark_connect(master = "local")

# sed

# sed 's/, *\r*$//' 'C:/Users/apdev/Downloads/NHS_prescription_data/Nov_2018/T201811PDPI BNFT.CSV' > 'T201811PDPI_BNFT.csv'

# sed -e '1d' -e 's/, *\r*$//' 'C:/Users/apdev/Downloads/NHS_prescription_data/Nov_2018/T201811PDPI BNFT.CSV' > T201811PDPI_BNFT.csv


source("R/spark_read_prescriptions.R")

pc <-
  sc %>%
  spark_read_postcodes(
    pin_get("postcode-outcodes.csv")
  )
pc

source("R/plot_postcode.R")
pc %>%
  plot_postcode(title = "UK postcodes (outcode level)")

pc %>%
  plot_postcode(title = "UK postcodes (outcode level)", hex = TRUE)



pres <- sc %>%
  spark_read_prescriptions(
    pin_get("t201901pdpi_bnft.csv")
  )

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

top_practices <-
  pres %>%
  group_by(period, practice) %>%
  summarise(
    items = sum(items, na.rm = TRUE),
    quantity = sum(quantity, na.rm = TRUE),
    nic = sum(nic, na.rm = TRUE),
    act_cost = sum(act_cost, na.rm = TRUE)
  ) %>%
  arrange(desc(act_cost)) %>%
  head(100)

top_practices


practices <-
  sc %>%
  spark_read_csv(
    pin_get("t201901addr_bnft.csv"),
    columns = c(
      "period",
      "practice",
      "surgery",
      "address",
      "road",
      "town",
      "shire",
      "postcode"
    )
  )

practices

top_practices %>%
  left_join(practices, by = "practice") %>%
  collect() %>%
  View()
