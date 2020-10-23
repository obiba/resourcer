#' Dremio DBI resource connector
#'
#' Makes a ODBC DBI connection to a Dremio server from a resource description.
#'
#' @docType class
#' @format A R6 object of class DremioResourceConnector
#' @import R6
#' @import httr
#' @export
DremioResourceConnector <- R6::R6Class(
  "DremioResourceConnector",
  inherit = ODBCResourceConnector,
  public = list(

    #' @description Creates a new DremioResourceConnector instance.
    #' @return A DremioResourceConnector object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a Dremio object: the URL scheme must be "odbc+dremio".
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      super$isFor(resource) && endsWith(super$parseURL(resource)$scheme, "+dremio")
    },
    
    #' @description Get the Dremio ODBC driver connection string.
    #' @param resource A valid resource object.
    #' @return The Dremio ODBC driver connection string.
    getConnectionString = function(resource) {
      url <- super$parseURL(resource)
      # example https://docs.dremio.com/client-applications/r.html
      connStr <- sprintf("DRIVER=Dremio;HOST=%s;PORT=%s;UID=%s;PWD=%s;AUTHENTICATIONTYPE=Basic Authentication;CONNECTIONTYPE=Direct", 
                         url$host, url$port, resource$identity, resource$secret)
      connStr
    }
  )
)
