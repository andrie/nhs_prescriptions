
<!-- README.md is generated from README.Rmd. Please edit that file -->

## nhs\_prescriptions

<!-- badges: start -->

<!-- badges: end -->

The goal of `nhs_prescriptions` is to demonstrate operations on
reasonably large data, using the NHS prescription level data as an
example.

## Setup

Install packages

``` r
install.packages(c(
  "sparklyr",
  "arrow",
  "tidyverse",
  "mapdata"
))
```

Install spark

``` r
sparklyr::spark_install()
```
