.make_shell_resource <- function(path = "/work/dir", exec = "plink,ls") {
  url <- httr::build_url(structure(
    list(
      scheme = "sh",
      path = path,
      query = list(exec = exec)
    ),
    class = "url"
  ))
  newResource(
    name = "test",
    url = url
  )
}

test_that("shell resource resolver works", {
  res <- .make_shell_resource()
  resolver <- ShellResourceResolver$new()
  expect_true(resolver$isFor(res))
  res$format <- "csv"
  expect_false(resolver$isFor(res))
})

test_that("shell resource client factory", {
  res <- .make_shell_resource()
  resolver <- ShellResourceResolver$new()
  client <- resolver$newClient(res)
  expect_equal(class(client), c("ShellResourceClient", "CommandResourceClient", "ResourceClient", "R6"))
  expect_error(client$asDataFrame(), "Operation not applicable")
})

test_that("shell resource client commands", {
  res <- .make_shell_resource()
  resolver <- ShellResourceResolver$new()
  client <- resolver$newClient(res)
  expect_equal(client$exec("ls", test = TRUE), "ls")
  expect_equal(client$exec("plink", params = c("--compress", "--out out.bin"), test = TRUE), "plink --compress --out out.bin")
  expect_error(client$exec("cd", "..", test = TRUE), "Shell command not allowed: cd")
})

test_that("shell resource client unknown command", {
  res <- .make_shell_resource(path = "/", exec = "unknown")
  resolver <- ShellResourceResolver$new()
  client <- resolver$newClient(res)
  res <- client$exec("unknown")
  expect_equal(res$status, -1)
  expect_equal(length(res$output), 0)
  expect_true(length(res$error)>0)
})

test_that("shell resource client exec output", {
  res <- .make_shell_resource(path = "/", exec = "pwd")
  resolver <- ShellResourceResolver$new()
  client <- resolver$newClient(res)
  res <- client$exec("pwd")
  if (res$status == 0) {
    expect_true(length(res$output)>0)
    expect_equal(res$output, "/")
    expect_equal(length(res$error), 0)
  }
})
