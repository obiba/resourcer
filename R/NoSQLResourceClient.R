#' NoSQL database resource client
#'
#' Resource client that connects to a NoSQL database supported by nodbi.
#'
#' @docType class
#' @format A R6 object of class NoSQLResourceClient
#' @import R6
#' @export
NoSQLResourceClient <- R6::R6Class(
  "NoSQLResourceClient",
  inherit = ResourceClient,
  public = list(
    initialize = function(resource, file.getter = NULL) {
      super$initialize(resource)
    },
    getConnection = function() {
      conn <- super$getConnection()
      if (is.null(conn)) {
        conn <- private$getNoDBIConnection()
        super$setConnection(conn)
      }
      conn
    },
    asDataFrame = function() {
      conn <- self$getConnection()
      table <- self$getTableName()
      private$loadTibble()
      tibble::as_tibble(nodbi::docdb_get(conn, table))
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
        url <- super$parseURL()
        if (url$scheme %in% c("mongodb", "mongodb+srv")) {
          conn$con$disconnect(TRUE)
        }
        super$setConnection(NULL)
      }
    }
  ),
  private = list(
    getNoDBIConnection = function() {
      resource <- super$getResource()
      url <- super$parseURL()
      # TODO use query to set additional connection arguments
      private$loadNoDBI()
      if (url$scheme %in% c("mongodb", "mongodb+srv")) {
        private$loadMongolite()
        dbname <- self$getDatabaseName()
        colname <- self$getTableName()
        if (is.null(colname)) {
          stop("MongoDB collection name is required", call. = FALSE)
        }
        url$path <- dbname # skip collection
        url$username <- resource$identity
        url$password <- resource$secret
        murl <- httr::build_url(url)
        nodbi::src_mongo(collection = colname, db = dbname, url = murl)
      } else {
        stop("Unknown NoSQL database: ", url$scheme, call. = FALSE)
      }
    },
    loadNoDBI = function() {
      if (!require("nodbi")) {
        install.packages("nodbi", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    },
    loadMongolite = function() {
      if (!require("mongolite")) {
        install.packages("mongolite", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    },
    loadTibble = function() {
      if (!require("tibble")) {
        install.packages("tibble", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
