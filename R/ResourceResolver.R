#' Resource resolver
#'
#' Helper class for building a Client that implements the access to the data or the
#' computation unit.
#'
#' @docType class
#' @format A R6 object of class ResourceResolver
#' @import R6
#' @import httr
#' @export
ResourceResolver <- R6::R6Class(
  "ResourceResolver",
  public = list(

    #' @description Creates a new ResourceResolver instance.
    #' @return A ResourceResolver object.
    initialize = function() {},

    #' @description Check that the provided object is of class "resource".
    #' @param x The resource object to evaluate.
    #' @return A logical.
    isFor = function(x) {
      "resource" %in% class(x)
    },

    #' @description Stub function to be implemented by subclasses. Makes an object which class inherits from ResourceClient.
    #' @param x The resource object to evaluate.
    #' @return The ResourceClient object that will access the provided resource.
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
#' @examples {
#' resourcer::getResourceResolvers()
#' }
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
#' @examples
#' \donttest{
#' resourcer::registerResourceResolver(MyFileFormatResourceResolver$new())
#' }
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
#' @examples
#' \donttest{
#' resourcer::unregisterResourceResolver("MyFileFormatResourceResolver")
#' }
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
#' @examples
#' \donttest{
#' library(resourcer)
#' res <- newResource(
#'   name = "CNSIM1",
#'   url = "file:///data/CNSIM1.sav",
#'   format = "spss"
#' )
#' resolver <- resolveResource(res)
#' }
#'
#' @export
resolveResource <- function(x) {
  resolver <- NULL
  if (is.null(x)) {
    stop("Resource object is NULL")
  } else if ("resource" %in% class(x)) {
    resRegistry <- getResourceResolvers()
    if (length(resRegistry)>0) {
      for (i in 1:length(resRegistry)) {
        res <- resRegistry[[i]]
        if (res$isFor(x)) {
          resolver <- res
        }
      }
    }
  } else  {
    stop("Not a 'resource' object")
  }
  if (is.null(resolver)) {
    stop("No resolver could be found for resource: ", x$url)
  }
  resolver
}
