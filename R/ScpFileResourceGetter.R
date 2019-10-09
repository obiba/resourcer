#' SCP file resource getter
#'
#' Access a file that is stored on a server accessible through SSH. Credentials apply.
#'
#' @section Methods:
#'
#' \code{$new(resource)} Create new ScpFileResourceGetter instance from provided resource object.
#' \code{$isFor(resource)} Get a logical that indicates that the file getter is applicable to the provided resource object.
#' \code{$downloadFile(resource)} Get the file described by the provided resource. Release the connection when done.
#'
#' @docType class
#' @format A R6 object of class ScpFileResourceGetter
#' @import R6
#' @export
ScpFileResourceGetter <- R6::R6Class(
  "ScpFileResourceGetter",
  inherit = FileResourceGetter,
  public = list(
    initialize = function() {},
    isFor = function(resource) {
      if (super$isFor(resource)) {
        super$parseURL(resource)$scheme == "scp"
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
        rpath <- url$path
        host <- paste0(resource$identity, "@", url$host)
        if (!is.null(url$port)) {
          host <- paste0(host, ":", url$port)
        }
        private$loadSsh()
        session <- ssh::ssh_connect(host, passwd = resource$secret)
        ssh::scp_download(session, files = rpath, to = downloadDir)
        ssh::ssh_disconnect(session)
        super$newFileObject(path, temp = TRUE)
      } else {
        NULL
      }
    }
  ),
  private = list(
    loadSsh = function() {
      if (!require("ssh")) {
        install.packages("ssh", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
