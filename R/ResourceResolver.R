#' Resource resolver
#'
#' Helper class for building a Client that implements the access to the data or the
#' computation unit.
#'
#' @section Methods:
#'
#' \code{$new()} Create new ResourceResolver instance.
#' \code{$isFor(x)} Get a logical that indicates that the resolver is applicable to the provided resource object.
#' \code{$newClient()} Make a client for the provided resource.
#'
#' @docType class
#' @format A R6 object of class ResourceResolver
#' @import R6
#' @import httr
#' @export
ResourceResolver <- R6::R6Class(
  "ResourceResolver",
  public = list(
    initialize = function() {},
    isFor = function(x) {
      "resource" %in% class(x)
    },
    newClient = function(x) {
      stop("Operation not implemented")
    }
  ),
  private = list(
    parseURL = function(x) {
      httr::parse_url(x$url)
    }
  )
)

#' Get resource resolvers registry
#'
#' Get the resource resolvers registry, create it if it does not exist.
#'
#' @export
getResourceResolvers <- function() {
  resRegistry <- getOption("resourcer.resolvers")
  if (is.null(resRegistry)) {
    resRegistry <- list()
    options(resourcer.resolvers = resRegistry)
  }
  resRegistry
}

#' Register a resource resolver
#'
#' Maintain an list of resource resolvers that will be called when a new
#' resource is to be resolved.
#'
#' @param x The resource resolver object to register.
#'
#' @export
registerResourceResolver <- function(x) {
  if ("ResourceResolver" %in% class(x)) {
    resRegistry <- getResourceResolvers()
    clazz <- class(x)[[1]]
    found <- any(unlist(lapply(resRegistry, function(res) { clazz %in% class(res) })))
    if (!found) {
      resRegistry <- append(resRegistry, x)
      options(resourcer.resolvers = resRegistry)
    }
  }
}

#' Remove a resource resolver from the registry
#'
#' Remove any resolvers with the provided class name.
#'
#' @param x The resource resolver class name to unregister.
#'
#' @export
unregisterResourceResolver <- function(x) {
  resRegistry <- getResourceResolvers()
  hasNotClass <- Vectorize(function(res) { !(x %in% class(res)) })
  resRegistry <- resRegistry[hasNotClass(resRegistry)]
  options(resourcer.resolvers = resRegistry)
}

#' Find a resource resolver
#'
#' Find the resolver that will make a client from the provided resource object.
#'
#' @param x The resource object which corresponding resolver is to be found.
#'
#' @return The corresponding ResourceResolver object or NULL if none applies.
#'
#' @export
resolveResource <- function(x) {
  resolver <- NULL
  if ("resource" %in% class(x)) {
    resRegistry <- getResourceResolvers()
    if (length(resRegistry)>0) {
      for (i in 1:length(resRegistry)) {
        res <- resRegistry[[i]]
        if (res$isFor(x)) {
          resolver <- res
        }
      }
    }
  }
  resolver
}
