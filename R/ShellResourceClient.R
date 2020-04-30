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
  inherit = CommandResourceClient,
  public = list(

    #' @description Create a ShellResourceClient instance. This client will interact wtih a computation resource using shell commands.
    #' @param resource The computation resource.
    #' @return The ShellResourceClient object.
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

    #' @description Get the command names that can be executed.
    #' @return A character vector
    getAllowedCommands = function() {
      private$.allowedCommands
    },

    #' @description Copy one or more files (wilcard * is supported in the file name (which can be a directory))
    #' @param file The file to copy.
    #' @param to The copy destination.
    #' @param verbose If TRUE, details the file operations on the console output.
    #' @return The path to the files having been copied.
    copyFile = function(file, to = ".", verbose = FALSE) {
      fileName <- basename(file)
      dirName <- normalizePath(dirname(file))
      toDirName <- normalizePath(to)
      if (dirName != toDirName) {
        file.copy(file, to, overwrite = TRUE)
      }
      file.path(toDirName, fileName)
    },

    #' @description Executes a shell command in the working directory specified in the resource's URL.
    #' @param command The command name.
    #' @param params A character vector of arguments to pass.
    #' @param test If TRUE, the command is printed but not executed (for debugging).
    #' @return The command execution result object.
    exec = function(command, params = NULL, test = FALSE) {
      private$loadSys()
      private$checkCommand(command, params)
      cmdStr <- paste(append(command, params), collapse = " ")
      if (test) {
        cmdStr
      } else {
        # do shell exec
        owd <- getwd()
        setwd(private$.workDir)
        tryCatch({
          res <- sys::exec_internal(cmd = command, args = params, error = FALSE)
          super$newResultObject(status = res$status, output = res$stdout, error = res$stderr, command = cmdStr)
        }, error = function(msg) {
          super$newResultObject(status = -1, output = NULL, error = msg, command = cmdStr, raw = FALSE)
        }, finally = {
          setwd(owd)
        })
      }
    }

  ),
  private = list(
    .allowedCommands = NULL,
    .workDir = ".",
    checkCommand = function(command, params) {
      if (!(command %in% private$.allowedCommands) && !("*" %in% private$.allowedCommands)) {
        stop("Shell command not allowed: ", command)
      }
      private$checkCommandParameters(params)
    },
    # verify that there is no minimal shell code injection in the parameters
    checkCommandParameters = function(params) {
      if (!is.null(params)) {
        pattern <- "[[:space:]\\|;&#`\\$]"
        if (any(grepl(pattern, params))) {
          stop("Invalid characters in the parameters")
        }
      }
    },
    loadSys = function() {
      if (!require("sys")) {
        install.packages("sys", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
