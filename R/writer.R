#' Write a Spark DataFrame to a TFRecord file
#' 
#' Serialize a Spark DataFrame to the TensorFlow TFRecord format for
#'   training or inference.
#'   
#' @param x A Spark DataFrame
#' @param path The path to the file. Needs to be accessible from the cluster.
#'   Supports the "hdfs://", "s3a://", and "file://" protocols.
#' @param record_type Output format of TensorFlow records. One of \code{"Example"} and 
#'   \code{"SequenceExample"}.
#' @param write_locality Determines whether the TensorFlow records are
#'   written locally on the workers or on a distributed file system. One of
#'   \code{"distributed"} and \code{"local"}. See Details for more information.
#' @param mode A \code{character} element. Specifies the behavior when data or
#'   table already exists. Supported values include: 'error', 'append', 'overwrite' and
#'   'ignore'. Notice that 'overwrite' will also change the column structure.
#'
#'   For more details see also \url{http://spark.apache.org/docs/latest/sql-programming-guide.html#save-modes}
#'   for your version of Spark.
#'   
#' @details For \code{write_locality = local}, each of the workers stores on the
#'   local disk a subset of the data. The subset that is stored on each worker
#'   is determined by the partitioning of the DataFrame. Each of the partitions
#'   is coalesced into a single TFRecord file and written on the node where the
#'   partition lives. This is useful in the context of distributed training, in which
#'   each of the workers gets a subset of the data to work on. When this mode is
#'   activated, the path provided to the writer is interpreted as a base path
#'   that is created on each of the worker nodes, and that will be populated with data
#'   from the DataFrame.
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
#' }
#' @export
spark_write_tfrecord <- function(
  x, path, record_type = c("Example", "SequenceExample"),
  write_locality = c("distributed", "local"), mode = NULL
) {
  sdf <- spark_dataframe(x)
  path <- spark_normalize_path(path)
  record_type <- match.arg(record_type)
  write_locality <- match.arg(write_locality)
  
  writer <- sdf %>%
    invoke("write") %>%
    invoke("format", "tfrecords") %>%
    invoke("option", "recordType", record_type) %>%
    invoke("option", "writeLocality", write_locality)
  
  if (!is.null(mode))
    writer <- invoke(writer, "mode", mode)
  
  invoke(writer, "save", path)
  invisible(NULL)
}