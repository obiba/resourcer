#' File resource getter
#'
#' Helper base class for getting the file described by the resource object. ResourceClient class implementations
#' can use this utility to retrieve files from any locations before processing them according to the declared
#' data format.
#'
#' @section Methods:
#'
#' \code{$new()} Create new FileResourceGetter instance.
#' \code{$isFor(resource)} Get a logical that indicates that the file getter is applicable to the provided resource object.
#' \code{$getFileObject(resource, ...)} Get the file described by the provided resource. Release the connection when done.
#'
#' @docType class
#' @format A R6 object of class FileResourceGetter
#' @import R6
#' @import httr
#' @export
FileResourceGetter <- R6::R6Class(
  "FileResourceGetter",
  public = list(
    initialize = function() {},
    isFor = function(resource) {
      "resource" %in% class(resource) && !is.null(resource$format)
    },
    getFileObject = function(resource, ...) {
      stop("Operation not applicable")
    },
    extractFileName = function(resource) {
      path <- private$parseURL(resource)$path
      segments <- strsplit(path, split = "/")[[1]]
      fileName <- segments[[length(segments)]]
      fileName
    },
    # create a temp dir in the session's temp dir
    makeDownloadDir = function(resource) {
      tmpdir <- file.path(tempdir(), sample(1000000:9999999, 1))
      dir.create(tmpdir, recursive = TRUE)
      tmpdir
    }
  ),
  private = list(
    parseURL = function(resource) {
      httr::parse_url(resource$url)
    },
    newFileObject = function(path, temp = FALSE) {
      structure(list(
        path = path,
        temp = temp),
        class = "resource.file")
    }
  )
)

#' Get file resource getters registry
#'
#' Get the \code{FileResourceGetter}s registry, create it if it does not exist.
#'
#' @export
getFileResourceGetters <- function() {
  registry <- getOption("resourcer.file.getters")
  if (is.null(registry)) {
    registry <- list()
    options(resourcer.file.getters = registry)
  }
  registry
}

#' Register a file resource getter
#'
#' Maintain an list of \code{FileResourceGetter}s that will be called when a new
#' file resource getter is to be found.
#'
#' @param x The file resource getter object to register.
#'
#' @export
registerFileResourceGetter <- function(x) {
  if ("FileResourceGetter" %in% class(x)) {
    registry <- getFileResourceGetters()
    clazz <- class(x)[[1]]
    found <- any(unlist(lapply(registry, function(res) { clazz %in% class(res) })))
    if (!found) {
      registry <- append(registry, x)
      options(resourcer.file.getters = registry)
    }
  }
}

#' Remove a file resource getter from the registry
#'
#' Remove any file resource getters with the provided class name.
#'
#' @param x The file resource getter class name to unregister.
#'
#' @export
unregisterFileResourceGetter <- function(x) {
  registry <- getFileResourceGetters()
  hasNotClass <- Vectorize(function(res) { !(x %in% class(res)) })
  registry <- registry[hasNotClass(registry)]
  options(resourcer.file.getters = registry)
}

#' Find a file resource getter
#'
#' Find the file resource getter that will download the file from the provided resource object.
#'
#' @param x The resource object which corresponding file getter is to be found.
#'
#' @return The corresponding FileResourceGetter object or NULL if none applies.
#'
#' @export
findFileResourceGetter <- function(x) {
  getter <- NULL
  if ("resource" %in% class(x)) {
    registry <- getFileResourceGetters()
    if (length(registry)>0) {
      for (i in 1:length(registry)) {
        res <- registry[[i]]
        if (res$isFor(x)) {
          getter <- res
        }
      }
    }
  }
  getter
}

