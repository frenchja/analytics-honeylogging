#' Wrap an expression with this function, if the expression errors, the error and stack
#' trace will be POSTed to honeybadger
#'
#' @param expr expression. Expression to be evaluated.
#' @param message character. Message to be displayed on henoeybadger for this error.
#' @param tags list. Additional tags for sorting on honeybadger UI.
#' @export
with_logging <- function(expr, class = "NA", message = "NA", tags = list()) {
  withCallingHandlers(
    eval(expr),
    error = function (error) log_error(error, class, message, tags)
  )
}


#' Log an error to honeybadger. The error's stack trace will be parsed for you.
#'
#' @param error expression. Error object.
#' @param message character. Message to be displayed on henoeybadger for this error.
#' @param tags list. Additional tags for sorting on honeybadger UI.
#' @export
log_error <- function(error, class = "NA", message = "NA", tags = list()) {
  # Get stacktrace if we have an error. If no error is provided, honeybadger's
  # backtrace array is instead an empty list
  if (is.null(error)) {
    backtrace <- list()
  } else {
    backtrace <- parse_error(error)
  }

  honeybadger_payload <- list(
    notifier = list(
      name = "honeylogging Notifier",
      url = "TBD"  # NOTE(Ahmed): This is useful in the web context; aka logging in Rails.
    ),
    error = list(
      class = class,
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


parse_error <- function(error) {
  trace <- stacktrace()
  signalCondition(error)

  trace_output <- lapply(trace, function(element) {
    # Turn unevaluated expressions into character strings and then concatenate.
    element$method <- paste(collapse = " ", deparse(width.cutoff = 500L, element$method))
    element
  })
  trace_output
}


post_to_honeybadger <- function(payload) {
  config <- httr::add_headers(
    Accept         = "application/json",
    "Content-Type" = "application/json",
    "X-API-Key"    = get_honeybadger_env_var()
  )
  resp <- httr::POST(
    HONEYBADGER_URL,
    body   = payload,
    encode = "json",
    config
  )
  if (resp$status == 201) {
    TRUE
  } else {
    FALSE
  }
}
