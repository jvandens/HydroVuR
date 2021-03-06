% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flatten_page_params.R
\name{flatten_page_params}
\alias{flatten_page_params}
\title{Return a dataframe of paginated results from the api}
\usage{
flatten_page_params(page_data)
}
\arguments{
\item{page_data}{a list of paginated results as returned from \code{hv_data}}
}
\value{

}
\description{
Return a dataframe of paginated results from the api
}
\examples{
\dontrun{
t <- flatten_page_params(data[[1]])
all <- purrr::map_dfr(data, flatten_page_params)
}
}
