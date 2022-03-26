#' Get OAuth2 token from HydroVu
#'
#' \code{hv_auth} returns a authentication token to HydroVu. Generally it should be the first
#' run prior to pulling more datasets.  A valid API credentials are needed on the HydroVu account.
#'
#' @param client_id The client id from the API page on HydroVu
#' @param client_secret The client secret from the API page on HydroVu
#' @param url HydroVu endpoint that serves token
#'
#' @return an OAuth2 client
#' @export
#'
#' @examples
#' \dontrun{
#' token <- hv_auth('my-client-id', 'my-secret')
#' }

hv_auth <- function(client_id, client_secret,
                         url = 'https://www.hydrovu.com/public-api/oauth/token') {

  client <- httr2::oauth_client(client_id,
                                token_url = url,
                                secret = client_secret)
  return(client)

}
