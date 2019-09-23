test_that("resource builder works", {
  res <- newResource(
    name = "CNSIM1",
    url = "opal+https://opal-demo.obiba.org/ws/files/data/CNSIM1.csv",
    identity = "administrator",
    secret = "password",
    clazz = "csv"
  )
  expect_equal(res$name, "CNSIM1")
  expect_equal(res$url, "opal+https://opal-demo.obiba.org/ws/files/data/CNSIM1.csv")
  expect_equal(res$identity, "administrator")
  expect_equal(res$secret, "password")
  expect_equal(class(res), c("resource", "csv"))

  res <- newResource(
    name = "CNSIM1",
    url = "opal+https://opal-demo.obiba.org/ws/files/data/CNSIM1.csv",
    secret = "DSDFrezerFgbgBC",
    clazz = "csv"
  )
  expect_null(res$identity)
})
