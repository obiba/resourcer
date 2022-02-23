#' SQL database resource client
#'
#' Resource client that connects to a SQL database supported by DBI.
#'
#' @docType class
#' @format A R6 object of class SQLResourceClient
#' @import R6
#' @export
SQLResourceClient <- R6::R6Class(
  "SQLResourceClient",
  inherit = ResourceClient,
  public = list(

    #' @description Creates a SQLResourceClient from a resource.
    #' @param resource The resource object.
    #' @param dbi.connector An optional DBIResourceConnector object. If not provided, it will be looked up in the DBIResourceConnector registry.
    #' @return The SQLResourceClient object.
    initialize = function(resource, dbi.connector = NULL) {
      super$initialize(resource)
      if (is.null(dbi.connector)) {
        private$.dbi.connector <- findDBIResourceConnector(resource)
      } else {
        private$.dbi.connector <- dbi.connector
      }
      if (is.null(private$.dbi.connector)) {
        stop("DBI resource connector cannot be found: either provide one or register one.")
      }
    },

    #' @description Get or create the DBI connection object that will access the resource.
    #' @return The DBI connection object.
    getConnection = function() {
      conn <- super$getConnection()
      if (is.null(conn)) {
        resource <- super$getResource()
        conn <- private$.dbi.connector$createDBIConnection(resource)
        super$setConnection(conn)
      }
      conn
    },

    #' @description Coerce the SQL table to a data.frame.
    #' @param ... Additional parameters (not used).
    #' @return A data.frame (more specifically a tibble).
    asDataFrame = function(...) {
      conn <- self$getConnection()
      private$.dbi.connector$readDBTable(conn, private$.resource)
    },

    #' @description Get the SQL table as a dplyr's tbl.
    #' @return A dplyr's tbl object.
    asTbl = function() {
      conn <- self$getConnection()
      private$.dbi.connector$readDBTibble(conn, private$.resource)
    },

    #' @description Silently close the DBI connection.
    close = function() {
      conn <- super$getConnection()
      if (!is.null(conn)) {
        private$.dbi.connector$closeDBIConnection(conn)
        super$setConnection(NULL)
      }
    }

  ),
  private = list(
    .dbi.connector = NULL
  )
)
