## Honeylogging (provisional name)


## Installation

This package is not yet available from CRAN. To install the latest development builds directly from GitHub, run this instead:

```R
if (!require('devtools')) install.packages('devtools')
devtools::install_github('avantcredit/analytics-honeylogging')
```

To ensure logging calls get sent to Honeybadger you need to set the `HONEYBADGER_API_KEY` environment variable.


## Usage

```R
with_logging(expr, ...)
```

Ex1: Attempt to evaluate an expression that could cause an error.
```R
with_logging(
  1+?,
  message="Attempted to add one to a question mark",
  tags=list("CRITICAL")
)
```

Ex2: Call `log_error` with your own error
```R
log_error(
  my_error_obj
  message="Can you year me now?...",
  tags=list("WARNING")
)
```

Ex3: Call `log_error` without any error
```R
log_error(
  NULL
  message="Got this far...",
  tags=list("DEBUG")
)
```


The `tags` argument maps to Honeybadger tags that will be used grouping errors.

The `message` argument is useful for explaining the context/reason for the error.
