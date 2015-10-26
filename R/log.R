library(bettertrace)
library(httr)
library(rjson)


with_logging <- function(expr) {
  tryCatch(eval(expr), error = parse_error)
}

parse_error <- function(error) {
  trace <- bettertrace::stacktrace()

  honey_badger_payload = list(backtrace = error)
  parsed_honey_badger_payload <- rjson::toJSON(honey_badger_payload)
  print(parsed_error)
}
