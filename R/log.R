# library(bettertrace)
library(crayon)
library(httr)
library(rjson)


with_logging <- function(expr) {
  tryCatch(eval(expr), error = parse_error)
}


HONEYBADGER_URL <- "https://api.honeybadger.io/v1/notices"

parse_error <- function(error) {
  # trace <- bettertrace::stacktrace()
  trace <- stacktrace()
  # trace <- simple_trace()

  class <- "foo"
  message <- "someError"
  tags <- list("foo", "bar")
  # browser()
  backtrace <- rjson::toJSON(trace)

  honeybadger_payload = list(
    notifier = list(
      name = "honeylogging Notifier",
      url = "TBD"
    ),
    error = list(
      class = paste(sample(c(0:9, letters, LETTERS), 10, replace=TRUE), collapse=""),
      tags = tags,
      backtrace = list(
        # list(number=55, file="foo.R", method="runtime_error")
      )
    ),
    request = list(
      context = list(foo=list()),
      params = list(foo=list()),
      session = list(foo=list()),
      cgi_data = list(foo=list()),
      user = list(foo=list()),
      user = list(foo=list())
    ),
    server = list(foo=list())
  )

  print(toJSON(honeybadger_payload))

  # Alternatively: Use system.time()
  ptm <- proc.time()
  post_to_honeybadger(honeybadger_payload)
  print(proc.time() - ptm)
}


post_to_honeybadger <- function(payload) {
  config <- httr::add_headers(
    Accept = "application/json",
    "Content-Type" = "application/json",
    "X-API-Key" = "68b92209" # "zFBGzLTP8nPkyWrHxQzV"
  )
  resp = httr::POST(
    # "http://requestb.in/1nf4l4r1",
    HONEYBADGER_URL,
    body=toJSON(payload),
    config
  )

  print(resp)
}

# with_logging(1+x)
