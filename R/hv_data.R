#' Get HydroVu data for a location and data range
#'
#' This is the main useful function of HydroVuR. Specify the Location ID and the date range to
#' download a dataframe of results.
#'
#' The resulting data frame will be in "long" format with a column
#' for all parameters at that location. It is unknown at this time if hydrovu allows for different
#' time resolutions for different parameters hance casting to a wide format (one column per parameter)
#' could result in a sparse dataframe thus safer to export in long format
#'
#' Note:  HydroVu API currently restricts API access to 1000 calls / minute and paginates ~10 records
#' per page.  Thus long time spans may take a while to download and/or timeout.
#'
#'
#' @param location_name Location name as provided in \code{hv_locations()}
#' @param start_time start date and time in ISO8601 string format:  YYYY-MM-DD HH:MM:SS
#' @param end_time end date and time in ISO8601 string format:  YYYY-MM-DD HH:MM:SS
#' @param tz time zone desired of returned data using \code{OlsonNames()}
#' @param token HydroVu API token as returned from \code{hv_auth()}
#' @param url base API url
#'
#' @return a dataframe
#' @export
#'
#' @examples
#' \dontrun{
#' data <- hv_data("test",
#'                 "2018-10-15 04:00:00", "2018-10-31 01:00:00", tz = "America/New_York", token)
#' }
hv_data <- function(location_name, start_time, end_time, tz = "UTC",
                    token, url = "https://www.hydrovu.com/public-api/v1/locations/") {

  # convert the time to timestamp
 # start <- as.numeric(as.POSIXct(start_time, tz = tz))
  #end <- as.numeric(as.POSIXct(end_time, tz = tz))
  
  # convert the time to timestamp, convert to UTC for lookup in Hydrovu
  start <- as.numeric(lubridate::with_tz(lubridate::ymd_hms(start_time, tz = tz), tzone = "UTC"))
  end <- as.numeric(lubridate::with_tz(lubridate::ymd_hms(end_time, tz = tz), tzone = "UTC"))

  # get the locations
  locs <- hv_locations(token)
  location_id <- locs[locs$name==location_name,]$id

  # build the url
  url <- paste0(url, location_id, "/data?endTime=", end, "&startTime=", start)

  req <- httr2::request(url)
  resp <-  req %>% httr2::req_oauth_client_credentials(token) %>% httr2::req_perform()
  data <- list(resp %>% httr2::resp_body_json())
  h <- resp %>% httr2::resp_headers()

  while (!is.null(h[["X-ISI-Next-Page"]]))
  {
    resp <- req %>% httr2::req_headers("X-ISI-Start-Page" = h[["X-ISI-Next-Page"]]) %>%
      httr2::req_oauth_client_credentials(token) %>% httr2::req_perform()
    data <- c(data, list(resp %>% httr2::resp_body_json()))
    h <- resp %>% httr2::resp_headers()

   # print(h[["X-ISI-Next-Page"]])

  }

  # get the params and units
  params <- hv_names(token, return = "params")
  units <- hv_names(token, return = "units")

  # collapse the paginated date and clean up
  df <- purrr::map_dfr(data, flatten_page_params) %>%
    dplyr::mutate(timestamp = lubridate::with_tz(lubridate::as_datetime(timestamp, tz = "UTC"), tzone = tz),   
                  #lubridate::as_datetime(timestamp, tz = tz),
                  Location = location_name) %>%
    dplyr::inner_join(params, by = "parameterId") %>%
    dplyr::inner_join(units, by = "unitId") %>%
    dplyr::select(-parameterId, -unitId) %>%
    dplyr::arrange(Parameter, timestamp)

  return(df)

}
