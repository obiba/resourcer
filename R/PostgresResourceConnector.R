#' Postgres DBI resource connector
#'
#' Makes a Postgres DBI connection from a resource description.
#'
#' @docType class
#' @format A R6 object of class PostgresResourceConnector
#' @import R6
#' @import httr
#' @export
PostgresResourceConnector <- R6::R6Class(
  "PostgresResourceConnector",
  inherit = DBIResourceConnector,
  public = list(

    #' @description Creates a new PostgresResourceConnector instance.
    #' @return A PostgresResourceConnector object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a Postgres object: the URL scheme must be "postgres" or "postgresql".
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      super$isFor(resource) && super$parseURL(resource)$scheme %in% c("postgres", "postgresql")
    },

    #' @description Creates a DBI connection object from a resource.
    #' @param resource A valid resource object.
    #' @return A DBI connection object.
    createDBIConnection = function(resource) {
      if (self$isFor(resource)) {
        super$loadDBI()
        private$loadRPostgres()
        url <- super$parseURL(resource)
        conn <- DBI::dbConnect(RPostgreSQL::PostgreSQL(), host = url$host, port = url$port,
                               user = resource$identity, password = resource$secret,
                               dbname = super$getDatabaseName(url))
      } else {
        stop("Resource is not located in a Postgres database")
      }
    }

  ),
  private = list(
    loadRPostgres = function() {
      if (!require("RPostgreSQL")) {
        install.packages("RPostgreSQL", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
