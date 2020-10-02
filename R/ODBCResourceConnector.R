#' ODBC DBI resource connector
#'
#' Makes a ODBC DBI connection from a resource description.
#'
#' @docType class
#' @format A R6 object of class ODBCResourceConnector
#' @import R6
#' @import httr
#' @export
ODBCResourceConnector <- R6::R6Class(
  "ODBCResourceConnector",
  inherit = DBIResourceConnector,
  public = list(

    #' @description Creates a new ODBCResourceConnector instance.
    #' @return A ODBCResourceConnector object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a ODBC object: the URL scheme must start with "odbc".
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      super$isFor(resource) && startsWith(super$parseURL(resource)$scheme, "odbc")
    },

    #' @description Creates a DBI connection object from a resource.
    #' @param resource A valid resource object.
    #' @return A DBI connection object.
    createDBIConnection = function(resource) {
      if (self$isFor(resource)) {
        super$loadDBI()
        private$loadRODBC()
        conn <- DBI::dbConnect(RODBC::ODBC(), connection = self$getConnectionString(resource))
      } else {
        stop("Resource is not located in a ODBC database")
      }
    },
    
    #' @description Get the specific ODBC driver connection string.
    #' @param resource A valid resource object.
    #' @return The ODBC driver connection string.
    getConnectionString = function(resource) {
      stop("ODBC driver connection string not implemented")
    }

  ),
  private = list(
    loadRODBC = function() {
      if (!require("RODBCDBI")) {
        install.packages("RODBCDBI", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
