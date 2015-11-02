simple_trace <- function() {
  n     <- length(sys.calls())
  trace <- Map(get_file_names, sys.calls(), sys.frames())
  trace <- strip_hidden(trace)
  msg   <- sanitize_message(geterrmessage())

  # TODO(Ahmed): Do I need this still??
  # We need to clear the internal error message so that ctrl+C interrupts
  # do not trigger a stack trace.
  on.exit(getFromNamespace(".Internal", "base")(seterrmessage("")), add = TRUE)

  if (length(trace) > 1 && nzchar(msg)) {
    cat(sep = "",
      paste(trace, collapse = "\n"), "\n\n",
      if (!is.na(msg)) {
        paste0(crayon::bold("Error"), ": ", safe_color(msg, "red"))
      }
    )
  }
  invisible(trace)
}

get_file_names <- function(sys_call, sys_frame) {
  srcref <- attr(call, "srcref")
  # if srcref is null use frame_text to get the frame text
}


#########################################################################

# call_description <- function(call, frame) {
#   srcref <- attr(call, "srcref")
#   if (is.null(srcref)) {
#     package_description(call, frame)
#   } else {
#     file_description(call, frame, srcref)
#   }
# }
#
# package_description <- function(call, frame) {
#   frame_info <- frame_text(frame)
#   text <- paste0("In ", frame_info, ": ", call_text(call))
#   if (!is.null(pkg <- attr(frame_info, "pkg"))) {
#     attr(text, "pkg") <- pkg
#   }
#   text
# }
#
# file_description <- function(call, frame, ref) {
#   paste0("In ", ref_text(frame, ref))
# }
#
# ref_text <- function(frame, ref) {
#   file <- ref_filename(ref)
#   browser()
#   if (nzchar(file)) {
#     file <- normalizePath(file)
#     paste0(decorate_file(file), ":", crayon::bold(as.character(ref[1L])),
#            ": ", trim_call(as.character(ref)))
#   } else {
#     frame_text(frame)
#   }
# }
#
# frame_text <- function(frame) {
#   if (identical(frame, .GlobalEnv)) {
#     structure(pkg = "_global",
#       "global environment"
#     )
#   } else if (nzchar(name <- environmentName(frame))) {
#     if (is.namespace(frame)) {
#       structure(pkg = name,
#         paste("package", crayon::green(as.character(name)))
#       )
#     # TODO: (RK) Temporarily disabled until I figure out if there is a way
#     # to tell between namespace and package env calls on the stack trace!
#     # } else if (grepl("^(package|imports):", name)) {
#     #  pkg_name <- strsplit(name, ":")[[1]][2]
#     #  structure(pkg = pkg_name,
#     #    paste("package", crayon::green(pkg_name))
#     #  )
#     } else {
#       paste("environment", name)
#     }
#   } else {
#     # TODO: (RK) Pre-compute cache of environments.
#     frame_text <- frame_text(parent.env(frame))
#     if (identical(attr(frame_text, "pkg"), "_global")) {
#       capture.output(print(frame))
#     } else {
#       frame_text
#     }
#   }
# }
#
# call_text <- function(call) {
#   trim_call(paste(deparse(call), collapse = " "))
# }
#
# trim_call <- function(pre_call_text) {
#   pre_call_text <- paste(pre_call_text, collapse = "\n")
#   call_text <- strtrim(pre_call_text, 120)
#   if (nchar(pre_call_text) > 120) {
#     call_text <- paste0(call_text, " [...]")
#   }
#   call_text
# }
#
# sanitize_message <- function(msg) {
#   gsub("^Error.*: ", "", as.character(msg))
# }
#
# strip_hidden <- function(trace) {
#   Filter(function(line) {
#     !identical(attr(line, "pkg"), "bettertrace")
#   }, trace)
# }
#
# safe_color <- function(msg, color) {
#   if (grepl("\033", msg, fixed = TRUE)) {
#     msg
#   } else {
#     get(color)(msg)
#   }
# }
#
# decorate_file <- function(file) {
#   file.path(dirname(file), crayon::yellow(basename(file)))
# }
#
# # For mockability in tests
is.namespace <- function(env) isNamespace(env)
ref_filename <- function(ref) attr(ref, "srcfile")$filename
