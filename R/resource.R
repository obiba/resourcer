#' Create a Resource
#'
#' Creates a new Resource structure.
#'
#' @param name Otpional human friendly name that identifies the resource.
#' @param url URL to access the resource whether it is data or computation capability.
#' @param identity User name or account ID (if credentials are applicable).
#' @param secret User password or token (if credentials are applicable).
#' @param format Data format, to help resource resolver identification and coercing to other formats.
#'  Optional, it will be both a property and an additional class name.
#'
#' @export
newResource <- function(name="", url, identity = NULL, secret = NULL, format = NULL) {
  cls <- c("resource")
  if (!is.null(format)){
    cls <- append(cls, format)
  }
  structure(
    list(
      name = name,
      url = url,
      identity = identity,
      secret = secret,
      format = format
    ),
    class = cls
  )
}

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

#' Creates a resource client
#'
#' From a resource object, find the corresponding resolver in the resolver registry
#' and create a new resource client.
#'
#' @param x The resource object which corresponding resolver is to be found.
#'
#' @return The corresponding ResourceClient object or NULL if none applies.
#'
#' @export
newResourceClient <- function(x) {
  client <- NULL
  resolver <- resolveResource(x)
  if (!is.null(resolver)) {
    client <- resolver$newClient(x)
  }
  client
}
