ref_filename <- function(ref) {
  attr(ref, "srcfile")$filename
}

frame_text <- function(frame) {
  if (identical(frame, .GlobalEnv)) {
    structure(pkg = "_global",
      "global environment"
    )
  } else if (nzchar(name <- environmentName(frame))) {
    if (is.namespace(frame)) {
      structure(pkg = name,
        paste("package ", as.character(name))
      )
    } else {
      paste("environment", name)
    }
  } else {
    # TODO: (RK) Pre-compute cache of environments.
    frame_text <- Recall(parent.env(frame))
    if (identical(attr(frame_text, "pkg"), "_global")) {
      capture.output(print(frame))
    } else {
      frame_text
    }
  }
}

stacktrace <- function() {
  Map(call_metadata, sys.calls(), sys.frames())
}

call_metadata <- function(call, frame) {
  srcref <- attr(call, "srcref")
  if (is.null(srcref)) {
    frame_info <- frame_text(frame)
    list(file = attr(frame_info, "pkg") %||%
         "unknown_environment", number = "0", method = call)
  } else {
    file <- ref_filename(srcref)
    if (nzchar(file)) {
      file <- normalizePath(file)
    } else {
      file <- "unknown_file"
    }
    list(file = file, number = as.character(srcref[[1]]), method = call)
  }
}


# For mockability in tests
is.namespace <- function(env) isNamespace(env)
ref_filename <- function(ref) attr(ref, "srcfile")$filename
