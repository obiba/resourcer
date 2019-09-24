#' Create a Resource
#'
#' Creates a new Resource structure.
#'
#' @param name Otpional human friendly name that identifies the resource.
#' @param url URL to access the resource whether it is data or computation capability.
#' @param identity User name or account ID (if credentials are applicable).
#' @param secret User password or token (if credentials are applicable).
#' @param clazz Additional class name, to help resolving data format.
#'
#' @export
newResource <- function(name="", url, identity = NULL, secret = NULL, clazz = NULL) {
  cls <- c("resource")
  if (!is.null(clazz)){
    cls <- append(cls, clazz)
  }
  structure(
    list(
      name = name,
      url = url,
      identity = identity,
      secret = secret
    ),
    class = cls
  )
}

#' Register a resource resolver
#'
#' Maintain an list of resource resolvers that will be called when a new
#' resource is to be resolved.
#'
#' @param x The resource resolver object to register.
#'
#' @export
registerResolver <- function(x) {
  if ("ResourceResolver" %in% class(x)) {
    resRegistry <- .getResolvers()
    message("Registering: ", class(x)[[1]])
    resRegistry <- append(resRegistry, x)
    options(resourcer.resolvers = resRegistry)
  }
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
    resRegistry <- .getResolvers()
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

#' Get resource resolvers registry from options
#' @keywords internal
.getResolvers <- function() {
  resRegistry <- getOption("resourcer.resolvers")
  if (is.null(resRegistry)) {
    resRegistry <- list()
    options(resourcer.resolvers = resRegistry)
  }
  resRegistry
}
