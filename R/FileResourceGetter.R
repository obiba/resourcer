#' File resource getter
#'
#' Helper base class for getting the file described by the resource object. ResourceClient class implementations
#' can use this utility to retrieve files from any locations before processing them according to the declared
#' data format.
#'
#' @docType class
#' @format A R6 object of class FileResourceGetter
#' @import R6
#' @import httr
#' @export
FileResourceGetter <- R6::R6Class(
  "FileResourceGetter",
  public = list(

    #' @description Creates a new FileResourceGetter instance.
    #' @return A FileResourceGetter object.
    initialize = function() {},

    #' @description Check that the provided parameter is of class "resource" and has a format defined.
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      "resource" %in% class(resource) && !is.null(resource$format)
    },

    #' @description Stub function which subclasses will implement to make a "resource.file" object from a resource.
    #' @param resource A valid resource object.
    #' @param ... Additional parameters that may be relevant for FileResourceGetter subclasses.
    #' @return A "resource.file" object.
    downloadFile = function(resource, ...) {
      stop("Operation not applicable")
    },

    #' @description Utility to get the base name from the file path.
    #' @param resource A valid resource object.
    #' @return The file base name.
    extractFileName = function(resource) {
      path <- private$parseURL(resource)$path
      basename(path)
    },

    #' @description Creates a directory where to download file in the R session's temporary directory. This directory will be flushed when the R session ends.
    #' @return The path to the download directory.
    makeDownloadDir = function() {
      tmpdir <- file.path(tempdir(), sample(1000000:9999999, 1))
      dir.create(tmpdir, recursive = TRUE)
      tmpdir
    }

  ),
  private = list(
    parseURL = function(resource) {
      httr::parse_url(resource$url)
    },
    buildURL = function(url) {
      httr::build_url(url)
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

