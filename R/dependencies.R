spark_dependencies <- function(spark_version, scala_version, ...) {
  sparklyr::spark_dependency(
    packages = c(
      sprintf("org.tensorflow:spark-tensorflow-connector_2.11:1.12.0")
    )
  )
}

#' @import sparklyr
.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
