#' GridFS file resource getter
#'
#' Access a file that is in the MongoDB file store (GridFS). Credentials may apply.
#'
#' @docType class
#' @format A R6 object of class GridFsFileResourceGetter
#' @import R6
#' @export
GridFsFileResourceGetter <- R6::R6Class(
  "GridFsFileResourceGetter",
  inherit = FileResourceGetter,
  public = list(

    #' @description Creates a new GridFsFileResourceGetter instance.
    #' @return A GridFsFileResourceGetter object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a GridFS object: either the URL scheme is "gridfs" or it is "mongodb"/"mongodb+srv" with a query parameter "prefix=fs" (that identifies GridFS collection names).
    #' @param resource The resource object to validate.
    #' @return A logical.
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

    #' @description Download the file from the MongoDB file store in a temporary location.
    #' @param resource A valid resource object.
    #' @param ... Unused additional parameters.
    #' @return The "resource.file" object.
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        fileName <- super$extractFileName(resource)
        downloadDir <- super$makeDownloadDir()
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
        stop("Resource is not located in a MongoDB file store (GridFS)")
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
