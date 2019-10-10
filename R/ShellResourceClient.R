#' Shell resource client
#'
#' Executes local system shell commands.
#'
#' @docType class
#' @format A R6 object of class ShellResourceClient
#' @import R6
#' @export
ShellResourceClient <- R6::R6Class(
  "ShellResourceClient",
  inherit = ResourceClient,
  public = list(
    initialize = function(resource) {
      super$initialize(resource)
      url <- super$parseURL()
      # allowed shell commands
      query <- url$query
      if (is.null(query) || is.null(query$exec)) {
        stop("Allowed shell commands are missing")
      }
      private$.allowedCommands <- strsplit(query$exec, split = ",")[[1]]
      # work directory
      path <- url$path
      if (nchar(path) > 0) {
        private$.workDir <- path
      }
    },
    # download one or more files (wilcard * is supported in the file name (which can be a directory))
    # return the paths of the files having been downloaded
    downloadFile = function(file, to = ".", verbose = FALSE) {
      fileName <- basename(file)
      dirName <- normalizePath(dirname(file))
      toDirName <- normalizePath(to)
      if (dirName != toDirName) {
        file.copy(file, to, overwrite = TRUE)
      }
      file.path(toDirName, fileName)
    },
    exec = function(command, params = NULL, test = FALSE) {
      private$loadSys()
      private$checkCommand(command)
      if (test) {
        paste(append(command, params), collapse = " ")
      } else {
        # do shell exec
        owd <- getwd()
        setwd(private$.workDir)
        res <- sys::exec_internal(cmd = command, args = params, error = FALSE)
        if (res$status == 0) {
          res$stdout <- strsplit(rawToChar(res$stdout), split = "\n")[[1]]
        } else {
          res$stderr <- strsplit(rawToChar(res$stderr), split = "\n")[[1]]
        }
        setwd(owd)
        res
      }
    }
  ),
  private = list(
    .allowedCommands = NULL,
    .workDir = ".",
    checkCommand = function(command) {
      if (!(command %in% private$.allowedCommands) && !("*" %in% private$.allowedCommands)) {
        stop("Shell command not allowed: ", command)
      }
    },
    loadSys = function() {
      if (!require("sys")) {
        install.packages("sys", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
