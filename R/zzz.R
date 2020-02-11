# register known file getters, DBI connectors and resolvers
.onAttach <- function(libname, pkgname) {
  doRegisterFileGetter <- function(res) {
    clazz <- class(res)[[1]]
    packageStartupMessage(paste0("Registering ", clazz, "..."))
    registerFileResourceGetter(res)
  }
  doRegisterFileGetter(LocalFileResourceGetter$new())
  doRegisterFileGetter(HttpFileResourceGetter$new())
  doRegisterFileGetter(ScpFileResourceGetter$new())
  doRegisterFileGetter(GridFsFileResourceGetter$new())
  doRegisterFileGetter(OpalFileResourceGetter$new())

  doRegisterDBIConnector <- function(res) {
    clazz <- class(res)[[1]]
    packageStartupMessage(paste0("Registering ", clazz, "..."))
    registerDBIResourceConnector(res)
  }
  doRegisterDBIConnector(MariaDBResourceConnector$new())
  doRegisterDBIConnector(PostgresResourceConnector$new())
  doRegisterDBIConnector(SparkResourceConnector$new())
  doRegisterDBIConnector(PrestoResourceConnector$new())

  doRegisterResolver <- function(res) {
    clazz <- class(res)[[1]]
    packageStartupMessage(paste0("Registering ", clazz, "..."))
    registerResourceResolver(res)
  }
  doRegisterResolver(TidyFileResourceResolver$new())
  doRegisterResolver(ShellResourceResolver$new())
  doRegisterResolver(SshResourceResolver$new())
  doRegisterResolver(RDataFileResourceResolver$new())
  doRegisterResolver(SQLResourceResolver$new())
  doRegisterResolver(NoSQLResourceResolver$new())
}

# unregister all resolvers
.onDetach <- function(libpath) {
  unregisterResourceResolver("ResourceResolver")
  unregisterFileResourceGetter("FileResourceGetter")
  unregisterDBIResourceConnector("DBIResourceConnector")
}
