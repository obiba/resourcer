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
    initialize = function(resource, file.getter = NULL) {
      super$initialize(resource)
    },
    getConnection = function() {
      conn <- super$getConnection()
      if (is.null(conn)) {
        conn <- private$getDBIConnection()
        super$setConnection(conn)
      }
      conn
    },
    # as.tbl means as dplyr::tbl
    asDataFrame = function(table = NULL, as.tbl = FALSE) {
      conn <- self$getConnection()
      tableName <- self$getTableName()
      if (is.null(tableName)) {
        if (is.null(table)) {
          private$loadTibble()
          tibble::tibble(table = DBI::dbListTables(conn))
        } else {
          private$readTable(table, as.tbl)
        }
      } else if (!is.null(table) && table != tableName) {
        stop("Table not accessible: ", table, call. = FALSE)
      } else {
        private$readTable(tableName, as.tbl)
      }
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
        DBI::dbDisconnect(conn)
        super$setConnection(NULL)
      }
    }
  ),
  private = list(
    readTable = function(table, as.tbl) {
      conn <- self$getConnection()
      if (!as.tbl) {
        private$loadTibble()
        tibble::as_tibble(DBI::dbReadTable(conn, table))
      } else {
        private$loadDBPlyr()
        tbl(conn, table)
      }
    },
    getDBIConnection = function() {
      resource <- super$getResource()
      url <- super$parseURL()
      # TODO use query to set additional connection arguments
      private$loadDBI()
      if (url$scheme %in% c("mysql", "mariadb")) {
        private$loadRMariaDB()
        conn <- DBI::dbConnect(RMariaDB::MariaDB(), host = url$host, port = url$port,
                               username = resource$identity, password = resource$secret,
                               dbname = self$getDatabaseName())
      } else if (url$scheme %in% c("postgres", "postgresql")) {
        private$loadRPostgres()
        conn <- DBI::dbConnect(RPostgres::Postgres(), host = url$host, port = url$port,
                               user = resource$identity, password = resource$secret,
                               dbname = self$getDatabaseName())
      } else {
        stop("Unknown SQL database: ", url$scheme, call. = FALSE)
      }
    },
    loadDBI = function() {
      if (!require("DBI")) {
        install.packages("DBI", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    },
    loadRMariaDB = function() {
      if (!require("RMariaDB")) {
        install.packages("RMariaDB", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    },
    loadRPostgres = function() {
      if (!require("RPostgres")) {
        install.packages("RPostgres", repos = "https://cloud.r-project.org", dependencies = TRUE)
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
