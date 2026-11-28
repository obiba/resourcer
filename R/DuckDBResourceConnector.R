#' DuckDB DBI resource connector
#'
#' Makes a DuckDB DBI connection from a resource description. The DuckDB database
#' file must be in the R server's local file system. The resource URL is
#' \code{duckdb:///path/to/file.duckdb} (or \code{duckdb:///C:/path/to/file.duckdb} on Windows),
#' optionally followed by \code{/table}: when the URL path is not an existing file, its last token
#' is the table name. Without a table, the resource is a general DuckDB connection (to be used with
#' the client's \code{getConnection()}). The connection is read-only.
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

    #' @description Get the DuckDB database file path from the resource URL.
    #' @param resource A valid resource object.
    #' @return The database file path.
    getDatabaseFile = function(resource) {
      private$splitPath(resource)$file
    },

    #' @description Get the table name from the resource URL, fails if there is none.
    #' @param resource A valid resource object.
    #' @return The table name.
    getTableName = function(resource) {
      table <- private$splitPath(resource)$table
      if (is.null(table)) {
        stop("No table in DuckDB resource URL: use the client's connection to query the database")
      }
      table
    },

    #' @description Disconnect the DBI connection and shutdown the DuckDB instance.
    #' @param conn A DBI connection object.
    closeDBIConnection = function(conn) {
      DBI::dbDisconnect(conn, shutdown = TRUE)
    }

  ),
  private = list(
    # URL path is the database file, optionally followed by the table name
    splitPath = function(resource) {
      tokens <- strsplit(super$parseURL(resource)$path, split = "/")[[1]]
      tokens <- tokens[tokens != ""]
      if (length(tokens) == 0) {
        stop("DuckDB resource URL must be duckdb:///path/to/file.duckdb[/table]")
      }
      toPath <- function(tks) {
        path <- paste(tks, collapse = "/")
        # windows drive letter (duckdb:///C:/path/to/file.duckdb)
        if (!grepl("^[A-Za-z]:$", tks[1])) {
          path <- paste0("/", path)
        }
        URLdecode(path)
      }
      file <- toPath(tokens)
      if (file.exists(file) && !dir.exists(file) || length(tokens) == 1) {
        list(file = file, table = NULL)
      } else {
        list(file = toPath(tokens[-length(tokens)]), table = URLdecode(tokens[length(tokens)]))
      }
    },
    loadDuckDB = function() {
      if (!require("duckdb")) {
        install.packages("duckdb", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
