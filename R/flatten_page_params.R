#' Return a dataframe of paginated results from the api
#'
#' @param page_data a list of paginated results as returned from \code{hv_data}
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' t <- flatten_page_params(data[[1]])
#' all <- purrr::map_dfr(data, flatten_page_params)
#' }
flatten_page_params <- function(page_data) {

  # create an output list
  out <- list()

  # pull parameters list
  d <- page_data[["parameters"]]

  # loop through the parameters
  for (i in seq_along(d)) {

    x <- d[[i]][["readings"]] %>%

      # collapse the readings for param[i] to data frame
      purrr::map_dfr(as.data.frame) %>%

      # mutate in the paramID and UnitID
      dplyr::mutate(parameterId = d[[i]][["parameterId"]],
                    unitId = d[[i]][["unitId"]],
                    customParameter = d[[i]][["customParameter"]], .before = timestamp)

    # append to output list
    out <- c(out, list(x))

  }

  # flatten output list to single dataframe
  df <- purrr::map_dfr(out, as.data.frame)
  return(df)

}
