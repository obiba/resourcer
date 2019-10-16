#' Postgres DBI resource connector
#'
#' Makes a Postgres DBI connection from a resource description.
#'
#' @section Methods:
#'
#' \code{$new()} Create new PostgresResourceConnector instance.
#' \code{$isFor(resource)} Get a logical that indicates that the DBI connector is applicable to the provided resource object.
#' \code{$createDBIConnection(resource, ...)} Get the DBI connection object described by the provided resource.
#' \code{$closeDBIConnection(conn)} Release the DBI connection when done.
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
    initialize = function() {},
    isFor = function(resource) {
      super$isFor(resource) && super$parseURL(resource)$scheme %in% c("postgres", "postgresql")
    },
    createDBIConnection = function(resource) {
      super$loadDBI()
      private$loadRPostgres()
      url <- super$parseURL(resource)
      conn <- DBI::dbConnect(RPostgres::Postgres(), host = url$host, port = url$port,
                             user = resource$identity, password = resource$secret,
                             dbname = super$getDatabaseName())
    }
  ),
  private = list(
    loadRPostgres = function() {
      if (!require("RPostgres")) {
        install.packages("RPostgres", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
