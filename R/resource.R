#' Create a Resource
#'
#' Creates a new Resource structure.
#'
#' @param name Otpional human friendly name that identifies the resource.
#' @param url URL to access the resource whether it is data or computation capability.
#' @param identity User name or account ID (if credentials are applicable).
#' @param secret User password or token (if credentials are applicable).
#' @param format Data format, to help resource resolver identification and coercing to other formats, optional.
#'
#' @examples {
#' # make a SPSS file resource
#' res <- resourcer::newResource(
#'   name = "CNSIM1",
#'   url = "file:///data/CNSIM1.sav",
#'   format = "spss"
#' )
#' }
#'
#' @export
newResource <- function(name="", url, identity = NULL, secret = NULL, format = NULL) {
  structure(
    list(
      name = name,
      url = url,
      identity = identity,
      secret = secret,
      format = format
    ),
    class = "resource"
  )
}
