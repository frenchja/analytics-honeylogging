# library(bettertrace)
library(crayon)
library(httr)
library(rjson)


with_logging <- function(expr, message = "NA", tags = list()) {
  withCallingHandlers(
    eval(expr),
    error = function (error) log_error(error, message, tags)
  )
}


HONEYBADGER_URL <- "https://api.honeybadger.io/v1/notices"

parse_error <- function(error) {
  trace <- stacktrace()
  # trace <- e$trace[seq_len(length(e$trace) - 2)]
  signalCondition(error)

  trace_output <- lapply(trace, function(element) {
    method <- if (is.call(element$method)) element$method[[1L]] else element$method
    element$method <- paste(collapse = " ", deparse(width.cutoff = 500L, call))
    element
  })
  trace_output
}

log_error <- function(error, message, tags) {

  # browser()
  backtrace <- parse_error(error)

  class <- "foo_class" # TODO
  tags <- tags

  browser()
  backtrace <- rjson::toJSON(backtrace)

  honeybadger_payload = list(
    notifier = list(
      name = "honeylogging Notifier",
      url = "TBD"  # TODO
    ),
    error = list(
      # Generate a random class
      # TODO: What qualifies as a class for R?
      class = paste(sample(c(0:9, letters, LETTERS), 10, replace=TRUE), collapse=""),
      tags = tags,
      message = message,
      backtrace = backtrace
    ),
    request = list(
      cgi_data = list(foo=list()),
      context = list(foo=list()),
      params = list(foo=list()),
      session = list(foo=list()),
      user = list(foo=list())
    ),
    server = list(
      hostname = Sys.info()["sysname"],
      nodename = Sys.info()["nodename"],
      release = Sys.info()["release"],
      version = Sys.info()["versions"],
      machine = Sys.info()["machine"],
      login = Sys.info()["login"],
      user = Sys.info()["user"],
      effective_user = Sys.info()["effective_user"]
    )
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
