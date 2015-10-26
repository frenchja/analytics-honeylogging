library(bettertrace)
library(httr)
library(rjson)


with_logging <- function(expr) {
  tryCatch(eval(expr), error = parse_error)
}

parse_error <- function(error) {
  trace <- bettertrace::stacktrace()

  class <- "foo"
  message <- "someError"
  tags <- list("foo", "bar")
  backtrace <- rjson::toJSON(trace)

  honeybadger_payload =  sprintf('{
"notifier":{
  "name":"honeylogging Notifier",
    "url":"TBD",
    "version":"1.0.0"
},
"error": {
  "class": %s,
  "message": %s,
  "tags": %s,
  },
 "backtrace": %s}', class, message, tags, backtrace)

  # list(backtrace = error)
  # parsed_honey_badger_payload <- rjson::toJSON(honey_badger_payload)
  print(honeybadger_payload)
}
