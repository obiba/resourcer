#' DBI resource connector
#'
#' Makes a DBI connection from a resource description, used in SQLResourceClient that is based on DBI.
#'
#' @docType class
#' @format A R6 object of class DBIResourceConnector
#' @import R6
#' @import httr
#' @export
DBIResourceConnector <- R6::R6Class(
  "DBIResourceConnector",
  public = list(

    #' @description Creates a new DBIResourceConnector instance
    #' @return A DBIResourceConnector object.
    initialize = function() {},

    #' @description Check that the provided parameter is of class "resource".
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      "resource" %in% class(resource)
    },

    #' @description Stub function which subclasses will implement to create a DBI connection object from a resource.
    #' @param resource A valid resource object.
    createDBIConnection = function(resource) {
      stop("Operation not applicable")
    },
    
    #' @description Get the SQL table name from the resource URL.
    #' @param resource A valid resource object.
    #' @return The SQL table name.
    getTableName = function(resource) {
      url <- httr::parse_url(resource$url)
      if (is.null(url$path)) {
        stop("No database table name")
      } else {
        # usually path is made of <db_name>/<table_name>
        URLdecode(basename(url$path))
      }
    },
    
    #' @description Read a table as a vanilla tibble using DBI connection object.
    #' @param conn A DBI connection object.
    #' @param resource A valid resource object.
    #' @return A vanilla tibble.
    readDBTable = function(conn, resource) {
      table <- self$getTableName(resource)
      private$loadTibble()
      tibble::as_tibble(DBI::dbReadTable(conn, table))
    },
    
    #' @description Read a table as a SQL tibble using DBI connection object.
    #' @param conn A DBI connection object.
    #' @param resource A valid resource object.
    #' @return A SQL tibble.
    readDBTibble = function(conn, resource) {
      table <- self$getTableName(resource)
      private$loadDBPlyr()
      dplyr::tbl(conn, table)
    },
    
    #' @description Disconnect the DBI connection.
    #' @param conn A DBI connection object.
    closeDBIConnection = function(conn) {
      DBI::dbDisconnect(conn)
    }

  ),
  private = list(
    loadDBI = function() {
      if (!require("DBI")) {
        install.packages("DBI", repos = "https://cloud.r-project.org")
      }
    },
    loadTibble = function() {
      if (!require("tibble")) {
        install.packages("tibble", repos = "https://cloud.r-project.org")
      }
    },
    loadDBPlyr = function() {
      if (!require("dplyr")) {
        install.packages("dplyr", repos = "https://cloud.r-project.org")
      }
      if (!require("dbplyr")) {
        install.packages("dbplyr", repos = "https://cloud.r-project.org")
      }
    },
    getDatabaseName = function(url) {
      strsplit(url$path, split = "/")[[1]][1]
    },
    parseURL = function(resource) {
      httr::parse_url(resource$url)
    },
    buildURL = function(url) {
      httr::build_url(url)
    }
  )
)

#' Get DBI resource connectors registry
#'
#' Get the \code{DBIResourceConnector}s registry, create it if it does not exist.
#'
#' @export
getDBIResourceConnectors <- function() {
  registry <- getOption("resourcer.dbi.connectors")
  if (is.null(registry)) {
    registry <- list()
    options(resourcer.dbi.connectors = registry)
  }
  registry
}

#' Register a DBI resource connector
#'
#' Maintain an list of \code{DBIResourceConnector}s that will be called when a new
#' DBI resource connector is to be found.
#'
#' @param x The DBI resource connector object to register.
#'
#' @export
registerDBIResourceConnector <- function(x) {
  if ("DBIResourceConnector" %in% class(x)) {
    registry <- getDBIResourceConnectors()
    clazz <- class(x)[[1]]
    found <- any(unlist(lapply(registry, function(res) { clazz %in% class(res) })))
    if (!found) {
      registry <- append(registry, x)
      options(resourcer.dbi.connectors = registry)
    }
  }
}

#' Remove a DBI resource connector from the registry
#'
#' Remove any DBI resource connectors with the provided class name.
#'
#' @param x The DBI resource connector class name to unregister.
#'
#' @export
unregisterDBIResourceConnector <- function(x) {
  registry <- getDBIResourceConnectors()
  hasNotClass <- Vectorize(function(res) { !(x %in% class(res)) })
  registry <- registry[hasNotClass(registry)]
  options(resourcer.dbi.connectors = registry)
}

#' Find a DBI resource connector
#'
#' Find the DBI resource connector that will download the DBI from the provided resource object.
#'
#' @param x The resource object which corresponding DBI connector is to be found.
#'
#' @return The corresponding DBIResourceConnector object or NULL if none applies.
#'
#' @export
findDBIResourceConnector <- function(x) {
  connector <- NULL
  if ("resource" %in% class(x)) {
    registry <- getDBIResourceConnectors()
    if (length(registry)>0) {
      for (i in 1:length(registry)) {
        res <- registry[[i]]
        if (res$isFor(x)) {
          connector <- res
        }
      }
    }
  }
  connector
}
