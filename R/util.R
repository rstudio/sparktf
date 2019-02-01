spark_normalize_path <- function(path) {
  # don't normalize paths that are urls
  if (grepl("[a-zA-Z]+://", path)) {
    path
  }
  else {
    normalizePath(path, mustWork = FALSE)
  }
}