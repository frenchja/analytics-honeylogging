context('honeylogging')
library(testthatsomemore)


with_options(error = stacktrace, {
  test_that("it does not print a stacktrace on a simple error", {
    expect_output(try(silent = TRUE, foo()), "")
  })

  # test_that("test that a simple stack trace is returned", {
  #   on.exit(rm(list = c("foo"), envir = .GlobalEnv), add = TRUE)
  #   within_file_structure(list("foo.R" = "
  #     foo <- function(...) { honeylogging::with_logging(1 + y) }
  #   "), {
  #     expect_equal(length(eval_in(foo())), 10)
  #   })
  # })
})
