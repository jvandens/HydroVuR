#' Return the list of locations for the given client from HydroVu
#'
#' @param client a valid OAuth2 token such as returned from \code{hv_auth()}
#' @param url HydroVu url that lists the locations
#'
#' @return a dataframe listing all the locations visible to the client
#' @export
#'
#' @examples
#' \dontrun{
#' locs <- hv_locations(client)
#' }


hv_locations <- function(client,
                          url = "https://www.hydrovu.com/public-api/v1/locations/list") {

  req <- httr2::request(url)
  locs <- req %>%
    httr2::req_oauth_client_credentials(client) %>%
    httr2::req_perform() %>%
    httr2::resp_body_json() %>%
    purrr::map_dfr(as.data.frame)

}
