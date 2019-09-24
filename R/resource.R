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
    resRegistry <- list()
    resRegistryName <- ".resourceResolvers"
    if (exists(resRegistryName, envir = parent.frame())) {
      resRegistry <- get(resRegistryName, envir = parent.frame())
    }
    message("Registering: ", class(x)[[1]])
    resRegistry <- append(resRegistry, x)
    assign(resRegistryName, resRegistry, envir = parent.frame())
  }
}

#' Find a resource resolver
#'
#' Find the resolver that will make a client from the provided resource object.
#'
#' @param x The resource object which corresponding resolver is to be found.
#'
#' @export
resolveResource <- function(x) {
  resRegistry <- list()
  resRegistryName <- ".resourceResolvers"
  if (exists(resRegistryName, envir = parent.frame())) {
    resRegistry <- get(resRegistryName, envir = parent.frame())
  }
  resolver <- NULL
  if (length(resRegistry)>0) {
    for (i in 1:length(resRegistry)) {
      res <- resRegistry[[i]]
      if (res$isFor(x)) {
        resolver <- res
      }
    }
  }
  resolver
}
