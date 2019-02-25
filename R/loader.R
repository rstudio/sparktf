#' Read a TFRecord File
#'
#' Read a TFRecord file as a Spark DataFrame.
#'
#' @param sc A spark conneciton.
#' @param name The name to assign to the newly generated table or the path to the file. Note that if a path is provided for the `name` argument
#'   then one cannot specify a name.
#' @param path The path to the file. Needs to be accessible from the cluster. Supports the "hdfs://", "s3a://" and "file://" protocols.
#' @param schema (Currently unsupported.) Schema of TensorFlow records.  If not provided, the schema is inferred from TensorFlow records.
#' @param record_type Input format of TensorFlow records. By default it is Example.
#' @param overwrite Boolean; overwrite the table with the given name if it already exists?
#' @examples
#' \dontrun{
#' iris_tbl <- copy_to(sc, iris)
#' data_path <- file.path(tempdir(), "iris")
#' df1 <- iris_tbl %>%
#' ft_string_indexer_model(
#'   "Species", "label",
#'   labels = c("setosa", "versicolor", "virginica")
#' )
#' 
#' df1 %>%
#' spark_write_tfrecord(
#'   path = data_path,
#'   write_locality = "local"
#' )
#' 
#' spark_read_tfrecord(sc, data_path)
#' }
#'
#' @export
spark_read_tfrecord <- function(sc, name = NULL, path = name, schema = NULL,
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