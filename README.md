# HydroVuR

R package for working with In-Situ HydroVu API

This package is a wrapper around the In-Situ [HydroVu API](https://www.hydrovu.com/public-api/docs/index.html) for water quality instruments

```{r}

library(HydroVuR)

client_id <- 'PublicApiDemo'
key <- 'PublicApiSecret'

# get a token
token <- hv_auth(client_id, key)

# get the locations
locs <- hv_locations(token)

# get the Friendly Names
params <- hv_names(token, return = "params")
units <- hv_names(token, return = "units")
both <- hv_names(token)

data <- hv_data("test", "2018-10-01 00:00:00", "2018-10-02 23:00:00", tz = "America/New_York", token)
data2 <- hv_data("In-Situ Poudre Well", "2017-07-14 04:00", "2017-07-31 01:00", tz = "UTC", token)

library(tidyverse)
library(units)
df <- data %>%
  select(-customParameter, -Units) %>%
  pivot_wider(names_from = Parameter, values_from = value)

#View(valid_udunits())

units(df$Pressure) = 'psi'
units(df$Temperature) = '°C'

ggplot(df, aes(x=timestamp, y = Pressure)) +
  geom_line() + geom_point()

ggplot(df, aes(x=timestamp, y = Temperature)) +
  geom_line() + geom_point()


```
