context('honeylogging')
library(testthatsomemore)

# test_that("test that a simple stack trace is returned", {
#   on.exit(rm(list = c("foo"), envir = .GlobalEnv), add = TRUE)
#   within_file_structure(list("foo.R" = "
#     foo <- function() { honeylogging::with_logging(1 + y) }
#   "), {
#     browser()
#     expect_equal(length(eval_in(foo())), 10)
#   })
# })
