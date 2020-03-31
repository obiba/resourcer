#' SSH resource client
#'
#' Connects to a SSH server.
#'
#' @docType class
#' @format A R6 object of class SshResourceClient
#' @import R6
#' @export
SshResourceClient <- R6::R6Class(
  "SshResourceClient",
  inherit = CommandResourceClient,
  public = list(

    #' @description Create a SshResourceClient instance. This client will interact wtih a computation resource using ssh commands.
    #' @param resource The computation resource.
    #' @return The SshResourceClient object.
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
      cmd <- ""
      if (nchar(path) > 0) {
        path <- paste0("/", path)
        cmd <- paste0("cd ", path, " && ")
      }
      private$.workDir <- path
      private$.commandPrefix <- cmd
    },

    #' @description Get or create the SSH connection object, for raw interaction.
    #' @return The SSH connection object.
    getConnection = function() {
      conn <- super$getConnection()
      if (is.null(conn)) {
        url <- super$parseURL()
        res <- super$getResource()
        host <- paste0(res$identity, "@", url$host)
        if (!is.null(url$port)) {
          host <- paste0(host, ":", url$port)
        }
        private$loadSsh()
        conn <- ssh::ssh_connect(host, passwd = res$secret)
        super$setConnection(conn)
      }
      conn
    },

    #' @description Download one or more files (wilcard * is supported in the file name (which can be a directory))
    #' @param file The file to download.
    #' @param to The download destination.
    #' @param verbose If TRUE, details the file operations on the console output.
    #' @return The paths of the files having been downloaded.
    downloadFile = function(file, to = ".", verbose = FALSE) {
      private$loadSsh()
      rfile <- file
      if (!startsWith(file, "/")) {
        # file path is relative to work dir
        rfile <- paste0(private$.workDir, "/", file)
      }
      files0 <- list.files(path = to, recursive = FALSE, full.names = FALSE, include.dirs = TRUE)
      # do ssh copy
      conn <- self$getConnection()
      ssh::scp_download(conn, files = rfile, to = to, verbose = verbose)
      files1 <- list.files(path = to, recursive = FALSE, full.names = FALSE, include.dirs = TRUE)
      isNotIn0 <- Vectorize(function(x) { !(x %in% files0) })
      downloaded <- files1[isNotIn0(files1)]
      sep <- "/"
      if (endsWith(to, "/")) {
        sep <- ""
      }
      unlist(lapply(downloaded, function(x) paste0(to, sep, x)))
    },

    #' @description Executes a ssh command.
    #' @param command The command name.
    #' @param params A named list of parameters.
    #' @param test If TRUE, the command is printed but not executed (for debugging).
    #' @return The command execution result object.
    exec = function(command, params = NULL, test = FALSE) {
      private$loadSsh()
      cmd <- private$makeCommand(command, params)
      if (test) {
        cmd
      } else {
        # do ssh exec
        conn <- self$getConnection()
        tryCatch({
          res <- ssh::ssh_exec_internal(conn, command = cmd, error = FALSE)
          super$newResultObject(status = res$status, output = res$stdout, error = res$stderr, command = cmd)
        }, error = function(msg) {
          super$newResultObject(status = -1, output = NULL, error = msg, command = cmdStr, raw = FALSE)
        })
      }
    },

    #' @description Close the SSH connection.
    close = function() {
      conn <- super$getConnection()
      if (!is.null(conn)) {
        ssh::ssh_disconnect(conn)
        super$setConnection(NULL)
      }
    }
  ),
  private = list(
    .allowedCommands = NULL,
    .commandPrefix = "",
    .workDir = "",
    makeCommand = function(command, params) {
      cmd <- private$.commandPrefix
      if ("*" %in% private$.allowedCommands || command %in% private$.allowedCommands) {
        cmd <- paste0(cmd, command)
        cmd <- paste(append(cmd, params), collapse = " ")
      } else {
        stop("Shell command not allowed: ", command)
      }
      cmd
    },
    loadSsh = function() {
      if (!require("ssh")) {
        install.packages("ssh", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
