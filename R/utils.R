#' Copy images required for the image classification demo to HDFS.
#'
#' Copy train- and test- images required for the dogs-vs-cats sparklyr image
#' classification demo to HDFS.
#'
#' The directory structure will be the following:
#'
#' <dest-dir>/
#'   \
#'    train/
#'    |\
#'    | dogs/
#'    |  \
#'    |   dog.*.jpg
#'    |
#'    |\
#'    | cats/
#'    |  \
#'    |   cat.*.jpg
#'    |
#'    test/
#'    |\
#'    | dogs/
#'    |  \
#'    |   dog.*.jpg
#'     \
#'      cats/
#'       \
#'        cat.*.jpg
#'
#' @param dest_dir The destination directory on HDFS containing images required
#'   for the demo (e.g., "/dogs-vs-cats"). If unspecified, then it will be a
#'   randomly generated path of the following form: /dogs-vs-cats_<UUID>.
#' @return The destination directory on HDFS (e.g., "/dogs-vs-cats_<UUID>").
#'
#' @export
copy_images_to_hdfs <- function(dest_dir = NULL) {
  dest_dir <- dest_dir %||% random_string("/dogs-vs-cats")
  src_dir <- system.file("extdata", package = "sparklyr.deeperer")

  exit_code <- system2("hdfs", paste("dfs -copyFromLocal", src_dir, dest_dir))
  if (exit_code != 0) {
    stop("'", do.call(paste, cmd), "' failed with exit code ", exit_code)
  }

  dest_dir
}
