#' Read a TFRecord File
#'
#' Read a TFRecord file as a Spark DataFrame.
#'
#' @param sc A spark conneciton.
#' @param name The name to assign to the newly generated table.
#' @param path The path to the file. Needs to be accessible from the cluster. Supports the "hdfs://", "s3a://" and "file://" protocols.
#' @param schema (Currently unsupported.) Schema of TensorFlow records.  If not provided, the schema is inferred from TensorFlow records.
#' @param record_type Input format of TensorFlow records. By default it is Example.
#' @param overwrite Boolean; overwrite the table with the given name if it already exists?
#' @export
spark_read_tfrecord <- function(sc, name, path, schema = NULL,
                                record_type = c("Example", "SequenceExample"),
                                overwrite = TRUE) {
  record_type <- match.arg(record_type)
  spark_read_source(
    sc,
    name = name,
    path = path,
    source = "tfrecords",
    options = list(recordType = record_type),
    overwrite = overwrite
  )
}