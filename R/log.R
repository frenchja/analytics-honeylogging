#' Wrap an expression with this function, and on error it will POST
#' error stacktrace to honeybadger
#'
#' @param expr expression. Expression to be evaluated.
#' @param message character. Message to be displayed on henoeybadger for this error.
#' @param tags list. Additional tags for sorting on honeybadger UI.
#' @export
with_logging <- function(expr, message = "NA", tags = list()) {
  withCallingHandlers(
    eval(expr),
    error = function (error) log_error(error, message, tags)
  )
}

parse_error <- function(error) {
  trace <- stacktrace()
  signalCondition(error)

  # browser()

  trace_output <- lapply(trace, function(element) {
    method <- if (is.call(element$method)) element$method[[1L]] else element$method
    element$method <- paste(collapse = " ", deparse(width.cutoff = 500L, method))
    element
  })
  trace_output
}

log_error <- function(error, message = "NA", tags = list()) {
  # Get stacktrace if we have an error
  if (is.null(error)) {
    backtrace <- list()
  } else {
    backtrace <- parse_error(error)
  }

  # browser()

  honeybadger_payload <- list(
    notifier = list(
      name = "honeylogging Notifier",
      url = "TBD"  # TODO
    ),
    error = list(
      # TODO: What qualifies as a class for R?
      # Generate a random class
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

  post_to_honeybadger(honeybadger_payload)
}


post_to_honeybadger <- function(payload) {
  config <- httr::add_headers(
    Accept         = "application/json",
    "Content-Type" = "application/json",
    "X-API-Key"    = get_honeybadger_env_var()
  )
  resp = httr::POST(
    HONEYBADGER_URL,
    body   = payload,
    encode = "json",
    config
  )
  TRUE
}
