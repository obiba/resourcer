#' MariaDB DBI resource connector
#'
#' Makes a MariaDB/MySQL DBI connection from a resource description.
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

    #' @description Creates a new MariaDBResourceConnector instance.
    #' @return A MariaDBResourceConnector object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a MySQL or MariaDB object: the URL scheme must be "mysql" or "mariadb".
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      super$isFor(resource) && super$parseURL(resource)$scheme %in% c("mysql", "mariadb")
    },

    #' @description Creates a DBI connection object from a resource.
    #' @param resource A valid resource object.
    #' @return A DBI connection object.
    createDBIConnection = function(resource) {
      if (self$isFor(resource)) {
        super$loadDBI()
        private$loadRMariaDB()
        url <- super$parseURL(resource)
        DBI::dbConnect(RMariaDB::MariaDB(), host = url$host, port = url$port,
                       username = resource$identity, password = resource$secret,
                       dbname = super$getDatabaseName(url))
      } else {
        stop("Resource is not located in a MySQL/MariaDB database")
      }
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
