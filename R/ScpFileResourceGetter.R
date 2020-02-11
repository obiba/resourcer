#' SCP file resource getter
#'
#' Access a file that is stored on a server accessible through SSH. Credentials apply.
#'
#' @docType class
#' @format A R6 object of class ScpFileResourceGetter
#' @import R6
#' @export
ScpFileResourceGetter <- R6::R6Class(
  "ScpFileResourceGetter",
  inherit = FileResourceGetter,
  public = list(

    #' @description Creates a ScpFileResourceGetter instance.
    #' @return The ScpFileResourceGetter object.
    initialize = function() {},

    #' @description Check that the provided resource is a file accessible by SCP: the resource URL scheme must be "scp".
    #' @param resource The resource object to evaluate.
    #' @return A logical.
    isFor = function(resource) {
      if (super$isFor(resource)) {
        super$parseURL(resource)$scheme == "scp"
      } else {
        FALSE
      }
    },

    #' @description Download the file described by the resource over an SSH connection.
    #' @param resource The resource that identifies the file.
    #' @param ... Additional parameters (not used).
    #' @return The "resource.file" object.
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        fileName <- super$extractFileName(resource)
        downloadDir <- super$makeDownloadDir()
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
