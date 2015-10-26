library(bettertrace)
library(httr)
library(rjson)


with_logging <- function(expr) {
  tryCatch(eval(expr), error = parse_error)
}

HONEYBADGER_URL <- "https://api.honeybadger.io/v1/notices"

parse_error <- function(error) {
  trace <- bettertrace::stacktrace()

  class <- "foo"
  message <- "someError"
  tags <- list("foo", "bar")
  backtrace <- rjson::toJSON(trace)

  honeybadger_payload = list(
    notifier = list(
      name = "honeylogging Notifier",
      url = "TBD"
    ),
    error = list(
      class = "foo"
    )
  )

  print(toJSON(honeybadger_payload))
}
