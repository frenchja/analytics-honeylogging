#' @param ... Named expressions are options, unnamed are evaluated.
#' @examples
#' with_options(digits = 20, print(pi)) # pi to 20 digits
#' print(pi) # 3.141593 -- the digits option is back to normal
with_options <- function(...) {
  opts  <- eval(substitute(alist(...)))
  names <- names(opts) %||% character(length(opts))

  opt_call <- list()
  for (name in names[nzchar(names)]) {
    opt_call[[name]] <- eval.parent(opts[[name]])
  }

  if (length(opt_call) > 0L) {
    old_opts <- do.call(options, opt_call)
    on.exit(options(old_opts), add = TRUE)
  }

  out <- NULL
  for (i in seq_along(opts)) {
    if (!nzchar(names[i])) {
      out <- eval.parent(opts[[i]])
    }
  }
  out
}
