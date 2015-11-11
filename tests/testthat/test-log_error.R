context('honeylogging')
library(testthatsomemore)


get_fake_payload <- function() {
  list(
    notifier = list(
      name = "honeylogging Notifier",
      url  = "TBD"  # TODO
    ),
    error = list(
      # TODO: What qualifies as a class for R?
      # Generate a random class
      class     = paste(sample(c(0:9, letters, LETTERS), 10, replace=TRUE), collapse=""),
      tags      = tags,
      message   = message,
      backtrace = backtrace
    ),
    request = list(
      cgi_data = list(foo=list()),
      context  = list(foo=list()),
      params   = list(foo=list()),
      session  = list(foo=list()),
      user     = list(foo=list())
    ),
    server = list(
      hostname       = Sys.info()["sysname"],
      nodename       = Sys.info()["nodename"],
      release        = Sys.info()["release"],
      version        = Sys.info()["versions"],
      machine        = Sys.info()["machine"],
      login          = Sys.info()["login"],
      user           = Sys.info()["user"],
      effective_user = Sys.info()["effective_user"]
    )
  )
}


test_that("test log_error", {
  with_mock(
    # `post_to_honeybadger`          = function(...) list(status=201),
    `httr::POST`          = function(...) list(status=201),
    res <- log_error(NULL, message = "an error", tags = list("ERROR")),
    expect_equal(res, TRUE)
  )
})
