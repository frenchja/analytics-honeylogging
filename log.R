library(httr)
library(logging)


# API_KEY = "zFBGzLTP8nPkyWrHxQzV"

tryCatch({
  foo <- function() { bar() + 1 }
  bar <- function() { baz() + 2 }
  foo()
}, error = function(e) {
  trace <- Map(bettertrace:::call_description, sys.calls(), sys.frames())
  browser()
  msg   <- conditionMessage(e)
  cat(sep = "", paste(trace, collapse = "\n"), "\n\n")
})

stacktrace <- function(e) {
  trace <- Map(call_description, sys.calls(), sys.frames())
  trace
}

call_description <- function(call, frame) {
  srcref <- attr(call, "srcref")
  if (is.null(srcref)) {
    package_description(call, frame)
  } else {
    file_description(call, frame, srcref)
  }
}

frame_text <- function(frame) {
  if (identical(frame, .GlobalEnv)) {
    structure(pkg = "_global",
      "global environment"
    )
  } else if (nzchar(name <- environmentName(frame))) {
    if (is.namespace(frame)) {
      structure(pkg = name,
        paste("package", crayon::green(as.character(name)))
      )
    # TODO: (RK) Temporarily disabled until I figure out if there is a way
    # to tell between namespace and package env calls on the stack trace!
    # } else if (grepl("^(package|imports):", name)) {
    #  pkg_name <- strsplit(name, ":")[[1]][2]
    #  structure(pkg = pkg_name,
    #    paste("package", crayon::green(pkg_name))
    #  )
    } else {
      paste("environment", name)
    }
  } else {
    # TODO: (RK) Pre-compute cache of environments.
    frame_text <- frame_text(parent.env(frame))
    if (identical(attr(frame_text, "pkg"), "_global")) {
      capture.output(print(frame))
    } else {
      frame_text
    }
  }



package_description <- function(call, frame) {
  frame_info <- frame_text(frame)
  text <- paste0("In ", frame_info, ": ", call_text(call))
  if (!is.null(pkg <- attr(frame_info, "pkg"))) {
    attr(text, "pkg") <- pkg
  }
  text
}
}
