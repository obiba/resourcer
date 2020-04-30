.make_ssh_resource <- function(host = "localhost", port = 22, path = "/work/dir", exec = "plink,ls", identity = "username", secret = "password") {
  url <- httr::build_url(structure(
    list(
      scheme = "ssh",
      hostname = host,
      port = port,
      path = path,
      query = list(exec = exec)
    ),
    class = "url"
  ))
  newResource(
    name = "test",
    url = url,
    identity = identity,
    secret = secret,
    format = NULL
  )
}

test_that("ssh resource resolver works", {
  res <- .make_ssh_resource()
  resolver <- SshResourceResolver$new()
  expect_true(resolver$isFor(res))
  res$format <- "csv"
  expect_false(resolver$isFor(res))
})

test_that("ssh resource client factory, connection refused", {
  res <- .make_ssh_resource()
  resolver <- SshResourceResolver$new()
  client <- resolver$newClient(res)
  expect_equal(class(client), c("SshResourceClient", "CommandResourceClient", "ResourceClient", "R6"))
  expect_error(client$asDataFrame(), "Operation not applicable")
  expect_error(client$getConnection())
})

test_that("ssh resource client factory, connection refused", {
  res <- .make_ssh_resource()
  resolver <- SshResourceResolver$new()
  client <- resolver$newClient(res)
  expect_equal(client$getAllowedCommands(), c("plink","ls"))
  expect_equal(client$exec("ls", test = TRUE), "cd /work/dir && ls")
  expect_equal(client$exec("plink", params = c("--compress", "--out", "out.bin"), test = TRUE), "cd /work/dir && plink --compress --out out.bin")
  expect_error(client$exec("cd", "..", test = TRUE), "Shell command not allowed: cd")
  expect_error(client$exec("ls", "-la .", test = TRUE), "Invalid characters in the parameters")
  expect_error(client$exec("ls", "-la&ls", test = TRUE), "Invalid characters in the parameters")
  expect_error(client$exec("ls", "-la|ls", test = TRUE), "Invalid characters in the parameters")
  expect_error(client$exec("ls", "-la;ls", test = TRUE), "Invalid characters in the parameters")
  expect_error(client$exec("ls", "-la#ls", test = TRUE), "Invalid characters in the parameters")
  expect_error(client$exec("ls", "`rm`", test = TRUE), "Invalid characters in the parameters")
  expect_error(client$exec("ls", "$PATH", test = TRUE), "Invalid characters in the parameters")
})

