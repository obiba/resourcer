#' Command resource client
#'
#' Base class for resource clients issuing commands and get a result with the status of the execution,
#' the output and the error messages.
#'
#' @docType class
#' @format A R6 object of class CommandResourceClient
#' @import R6
#' @export
CommandResourceClient <- R6::R6Class(
  "CommandResourceClient",
  inherit = ResourceClient,
  public = list(

    #' @description Creates a new CommandResourceClient instance
    #' @param resource A valid resource object.
    #' @return A CommandResourceClient object.
    initialize = function(resource) {
      super$initialize(resource)
    }

  ),
  private = list(
    newResultObject = function(status, output, error, command, raw = TRUE) {
      outstr <- output
      if (!is.null(output) && raw) {
        outstr <- strsplit(rawToChar(output), split = "\n")[[1]]
      }
      errstr <- error
      if (!is.null(error) && raw) {
        errstr <- strsplit(rawToChar(error), split = "\n")[[1]]
      }
      structure(list(
        status = status,
        output = outstr,
        error = errstr,
        command = command),
        class = "resource.exec")
    }
  )
)
