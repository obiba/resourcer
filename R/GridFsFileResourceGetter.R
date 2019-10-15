#' GridFS file resource getter
#'
#' Access a file that is in the MongoDB file store (GridFS). Credentials may apply.
#'
#' @section Methods:
#'
#' \code{$new(resource)} Create new GridFsFileResourceGetter instance from provided resource object.
#' \code{$isFor(resource)} Get a logical that indicates that the file getter is applicable to the provided resource object.
#' \code{$downloadFile(resource)} Get the file described by the provided resource. Release the connection when done.
#'
#' @docType class
#' @format A R6 object of class GridFsFileResourceGetter
#' @import R6
#' @export
GridFsFileResourceGetter <- R6::R6Class(
  "GridFsFileResourceGetter",
  inherit = FileResourceGetter,
  public = list(
    initialize = function() {},
    isFor = function(resource) {
      if (super$isFor(resource)) {
        url <- super$parseURL(resource)
        scheme <- url$scheme
        query <- url$query
        scheme == "gridfs" || (scheme %in% c("mongodb", "mongodb+srv") && query$prefix == "fs")
      } else {
        FALSE
      }
    },
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        fileName <- super$extractFileName(resource)
        downloadDir <- super$makeDownloadDir(resource)
        path <- file.path(downloadDir, fileName)

        url <- super$parseURL(resource)
        if (url$scheme == "gridfs") {
          url$scheme <- "mongodb"
        }
        url$query$prefix <- NULL
        rpath <- url$path
        db <- strsplit(rpath)[[1]]
        url$path <- db
        url$username <- resource$identity
        url$password <- resource$secret
        urlstr <- super$buildURL(url)

        private$loadMongoLite()
        fs <- mongolite::gridfs(db, url = urlstr, prefix = "fs")
        fs$download(fileName, path = downloadDir)
        super$newFileObject(path, temp = TRUE)
      } else {
        NULL
      }
    }
  ),
  private = list(
    loadMongoLite = function() {
      if (!require("mongolite")) {
        install.packages("mongolite", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
