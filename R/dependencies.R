spark_dependencies <- function(spark_version, scala_version, ...) {
  spark_dependency(
    package = "databricks:spark-deep-learning:1.5.0-spark2.4-s_2.11",
    repositories = "https://repos.spark-packages.org"
  )
}
