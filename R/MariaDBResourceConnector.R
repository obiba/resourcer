#' MariaDB DBI resource connector
#'
#' Makes a MariaDB/MySQL DBI connection from a resource description.
#'
#' @section Methods:
#'
#' \code{$new()} Create new MariaDBResourceConnector instance.
#' \code{$isFor(resource)} Get a logical that indicates that the DBI connector is applicable to the provided resource object.
#' \code{$createDBIConnection(resource, ...)} Get the DBI connection object described by the provided resource.
#' \code{$closeDBIConnection(conn)} Release the DBI connection when done.
#'
#' @docType class
#' @format A R6 object of class MariaDBResourceConnector
#' @import R6
#' @import httr
#' @export
MariaDBResourceConnector <- R6::R6Class(
  "MariaDBResourceConnector",
  inherit = DBIResourceConnector,
  public = list(
    initialize = function() {},
    isFor = function(resource) {
      super$isFor(resource) && super$parseURL(resource)$scheme %in% c("mysql", "mariadb")
    },
    createDBIConnection = function(resource) {
      super$loadDBI()
      private$loadRMariaDB()
      url <- super$parseURL(resource)
      DBI::dbConnect(RMariaDB::MariaDB(), host = url$host, port = url$port,
                     username = resource$identity, password = resource$secret,
                     dbname = super$getDatabaseName(url))
    }
  ),
  private = list(
    loadRMariaDB = function() {
      if (!require("RMariaDB")) {
        install.packages("RMariaDB", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
