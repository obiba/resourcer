# register known resolvers
.onAttach <- function(libname, pkgname) {
  doRegister <- function(res) {
    clazz <- class(res)[[1]]
    packageStartupMessage(paste0("Registering ", clazz, "..."))
    registerResourceResolver(res)
  }
  doRegister(FileResourceResolver$new())
  doRegister(SshResourceResolver$new())
}

# unregister all resolvers
.onDetach <- function(libpath) {
  unregisterResourceResolver("ResourceResolver")
}
