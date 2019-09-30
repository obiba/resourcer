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
      cmd <- ""
      if (nchar(path) > 0) {
        cmd <- paste0("cd /", path, " && ")
      }
      private$.commandPrefix <- cmd
    },
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
    exec = function(command, params = "", test = FALSE) {
      private$loadSsh()
      cmd <- private$makeCommand(command, params)
      if (test) {
        cmd
      } else {
        # do ssh exec
      }

    },
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
    makeCommand = function(command, params) {
      cmd <- private$.commandPrefix
      if ("*" %in% private$.allowedCommands || command %in% private$.allowedCommands) {
        cmd <- paste0(cmd, command)
        if (nchar(params) > 0) {
          cmd <- paste0(cmd, " ", params)
        }
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
