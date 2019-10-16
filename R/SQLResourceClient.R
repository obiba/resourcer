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
    getConnection = function() {
      conn <- super$getConnection()
      if (is.null(conn)) {
        resource <- super$getResource()
        conn <- private$.dbi.connector$createDBIConnection(resource)
        super$setConnection(conn)
      }
      conn
    },
    asDataFrame = function(table = NULL) {
      private$asTable(table, FALSE)
    },
    asTbl = function(table = NULL) {
      private$asTable(table, TRUE)
    },
    getDatabaseName = function() {
      url <- super$parseURL()
      strsplit(url$path, split = "/")[[1]][1]
    },
    getTableName = function() {
      url <- super$parseURL()
      name <- basename(url$path)
      if (name == url$path) {
        # database name only
        NULL
      } else {
        name
      }
    },
    close = function() {
      conn <- super$getConnection()
      if (!is.null(conn)) {
        private$.dbi.connector$closeDBIConnection(conn)
        super$setConnection(NULL)
      }
    }
  ),
  private = list(
    .dbi.connector = NULL,
    # use.dplyr means returning a "table" convenient for dplyr processing
    asTable = function(table = NULL, use.dplyr = FALSE) {
      conn <- self$getConnection()
      tableName <- self$getTableName()
      if (is.null(tableName)) {
        if (is.null(table)) {
          private$loadTibble()
          tibble::tibble(table = DBI::dbListTables(conn))
        } else {
          private$readTable(table, use.dplyr)
        }
      } else if (!is.null(table) && table != tableName) {
        stop("Table not accessible: ", table, call. = FALSE)
      } else {
        private$readTable(tableName, use.dplyr)
      }
    },
    readTable = function(table, use.dplyr) {
      conn <- self$getConnection()
      if (!use.dplyr) {
        private$loadTibble()
        tibble::as_tibble(DBI::dbReadTable(conn, table))
      } else {
        private$loadDBPlyr()
        dplyr::tbl(conn, table)
      }
    },
    loadTibble = function() {
      if (!require("tibble")) {
        install.packages("tibble", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    },
    loadDBPlyr = function() {
      if (!require("dplyr")) {
        install.packages("dplyr", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
      if (!require("dbplyr")) {
        install.packages("dbplyr", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
