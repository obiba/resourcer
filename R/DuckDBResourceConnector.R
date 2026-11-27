#' DuckDB DBI resource connector
#'
#' Makes a DuckDB DBI connection from a resource description. The DuckDB database
#' file must be in the R server's local file system. The resource URL is
#' \code{duckdb:///path/to/file.duckdb/table}: the last path token is the table name,
#' the preceding ones are the database file path. The connection is read-only.
#'
#' @docType class
#' @format A R6 object of class DuckDBResourceConnector
#' @import R6
#' @import httr
#' @export
DuckDBResourceConnector <- R6::R6Class(
  "DuckDBResourceConnector",
  inherit = DBIResourceConnector,
  public = list(

    #' @description Creates a new DuckDBResourceConnector instance.
    #' @return A DuckDBResourceConnector object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a DuckDB object: the URL scheme must be "duckdb".
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      super$isFor(resource) && super$parseURL(resource)$scheme == "duckdb"
    },

    #' @description Creates a read-only DBI connection object from a resource.
    #' @param resource A valid resource object.
    #' @return A DBI connection object.
    createDBIConnection = function(resource) {
      if (self$isFor(resource)) {
        super$loadDBI()
        private$loadDuckDB()
        DBI::dbConnect(duckdb::duckdb(), dbdir = self$getDatabaseFile(resource), read_only = TRUE)
      } else {
        stop("Resource is not located in a DuckDB database")
      }
    },

    #' @description Get the DuckDB database file path from the resource URL (all path tokens but the last one).
    #' @param resource A valid resource object.
    #' @return The database file path.
    getDatabaseFile = function(resource) {
      tokens <- strsplit(super$parseURL(resource)$path, split = "/")[[1]]
      tokens <- tokens[tokens != ""]
      if (length(tokens) < 2) {
        stop("DuckDB resource URL must be duckdb:///path/to/file.duckdb/table")
      }
      URLdecode(paste0("/", paste(tokens[-length(tokens)], collapse = "/")))
    },

    #' @description Disconnect the DBI connection and shutdown the DuckDB instance.
    #' @param conn A DBI connection object.
    closeDBIConnection = function(conn) {
      DBI::dbDisconnect(conn, shutdown = TRUE)
    }

  ),
  private = list(
    loadDuckDB = function() {
      if (!require("duckdb")) {
        install.packages("duckdb", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
