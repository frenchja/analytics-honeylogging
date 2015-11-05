get_honeybadger_env_var <- function() {
  ENV_VARS_HONEYBADGER_API_KEY <- Sys.getenv('HONEYBADGER_API_KEY')

  if (!(nzchar(ENV_VARS_HONEYBADGER_API_KEY))) {
    stop('You need to set HONEYBADGER_API_KEY env var.')
  }

  ENV_VARS_HONEYBADGER_API_KEY
}
