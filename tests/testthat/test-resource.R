test_that("resource builder works", {
  res <- newResource(
    name = "CNSIM1",
    url = "opal+https://opal-demo.obiba.org/ws/files/data/CNSIM1.csv",
    identity = "administrator",
    secret = "password",
    format = "csv"
  )
  expect_equal(res$name, "CNSIM1")
  expect_equal(res$url, "opal+https://opal-demo.obiba.org/ws/files/data/CNSIM1.csv")
  expect_equal(res$identity, "administrator")
  expect_equal(res$secret, "password")
  expect_equal(res$format, "csv")
  expect_equal(class(res), "resource")

  res <- newResource(
    name = "CNSIM1",
    url = "opal+https://opal-demo.obiba.org/ws/files/data/CNSIM1.csv",
    secret = "DSDFrezerFgbgBC",
    format = "csv"
  )
  expect_null(res$identity)
})
