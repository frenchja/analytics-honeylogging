context('honeylogging')
library(testthatsomemore)


with_options(error = stacktrace, {
  test_that("test that a simple stack trace is returned", {
    f <- function() g()
    g <- function() h()
    h <- function() {
      calls = tail(sys.calls(), 3)
      frames = tail(sys.frames(), 3)
      Map(call_metadata, calls, frames)
    }
    trace <- f()

    # Stack trace should have len of 3 for the f, g, and h calls
    expect_equal(length(trace), 3)

    # Verify method name and file ending of last item in the stack trace
    expect_equal(deparse(trace[[3]]$method), "h()")
    expect_equal(grep("/tests/testthat/test-call_metadata.R", trace[[3]]$file), 1)
  })
})
