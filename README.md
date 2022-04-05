# HydroVuR

## Introduction

R package for working with In-Situ HydroVu API

`HydroVuR` is a wrapper around the In-Situ [HydroVu API](https://www.hydrovu.com/public-api/docs/index.html) for water quality instruments

## Installation

Install from github with `devtools`:

```{r}
devtools::install_github("jvandens/HydroVuR")
```
## Functions Overview

`HydroVu` includes the following functions, sorted by the order they would generally be applied:

- `hv_auth` is used to get an authorization token, must supply a valid client id and client secret that is created on the HydroVu "Users" page under Manage API Credentials.

- `hv_locations` is used to return a `data.frame` of locations visible with the supplied credentials

- `hv_data` is used to download a `data.frame` of all data at a single location between to `POSIXct` datetimes

- `hv_names` can be used to download a `data.frame` of names of all parameters and units in HydroVu. Generally not needed directly as `hv_data` will call it automatically

## Getting Started

The following examples shows a typical workflow to download data from a single location.

```{r}

library(HydroVuR)

# Enter user api credentials
client_id <- 'PublicApiDemo'
key <- 'PublicApiSecret'

# get a token
token <- hv_auth(client_id, key)

# get the locations
locs <- hv_locations(token)

# get data
data <- hv_data("In-Situ Poudre Well", "2017-07-14 04:00", "2017-07-31 01:00", tz = "UTC", token)

# get the Friendly Names for parameters and units for reference.
# can be returned indiviually as data.frames or as a list of both data.frames
params <- hv_names(token, return = "params")
units <- hv_names(token, return = "units")
both <- hv_names(token)

```

## Contact

Author:  Jaak Van den Sype
Company:  HDR Inc.



