#' DBI resource connector
#'
#' Makes a DBI connection from a resource description, used in SQLResourceClient that is based on DBI.
#'
#' @section Methods:
#'
#' \code{$new()} Create new DBIResourceConnector instance.
#' \code{$isFor(resource)} Get a logical that indicates that the DBI connector is applicable to the provided resource object.
#' \code{$createDBIConnection(resource, ...)} Get the DBI connection object described by the provided resource.
#' \code{$closeDBIConnection(conn)} Release the DBI connection when done.
#'
#' @docType class
#' @format A R6 object of class DBIResourceConnector
#' @import R6
#' @import httr
#' @export
DBIResourceConnector <- R6::R6Class(
  "DBIResourceConnector",
  public = list(
    initialize = function() {},
    isFor = function(resource) {
      "resource" %in% class(resource)
    },
    createDBIConnection = function(resource) {
      stop("Operation not applicable")
    },
    closeDBIConnection = function(conn) {
      DBI::dbDisconnect(conn)
    }
  ),
  private = list(
    loadDBI = function() {
      if (!require("DBI")) {
        install.packages("DBI", repos = "https://cloud.r-project.org", dependencies = TRUE)
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
