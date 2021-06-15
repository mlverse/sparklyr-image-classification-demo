#' Run the image classification demo.
#'
#' Run the dogs-vs-cats sparklyr image classification demo.
#'
#' @param sc The Spark connection.
#' @return The trained image classification model.
#'
#' @export
run_demo <- function(sc) {
  data_dir <- copy_images_to_hdfs()

  # extract features from train- and test-data
  image_data <- list()
  for (x in c("train", "test")) {
    # import
    image_data[[x]] <- c("dogs", "cats") %>%
      lapply(
        function(label) {
          numeric_label <- ifelse(identical(label, "dogs"), 1L, 0L)
          spark_read_image(
            sc, dir = file.path(data_dir, x, label, fsep = "/")
          ) %>%
            dplyr::mutate(label = numeric_label)
        }
      ) %>%
        do.call(sdf_bind_rows, .)
  
    dl_featurizer <- invoke_new(
      sc,
      "com.databricks.sparkdl.DeepImageFeaturizer",
      random_string("dl_featurizer") # uid
    ) %>%
      invoke("setModelName", "InceptionV3") %>%
      invoke("setInputCol", "image") %>%
      invoke("setOutputCol", "features")
    image_data[[x]] <-
      dl_featurizer %>%
      invoke("transform", spark_dataframe(image_data[[x]])) %>%
      sdf_register()
  }

  label_col <- "label"
  prediction_col <- "prediction"
  pipeline <- ml_pipeline(sc) %>%
    ml_logistic_regression(
      features_col = "features",
      label_col = label_col,
      prediction_col = prediction_col
    )
  model <- pipeline %>% ml_fit(image_data$train)
  predictions <- model %>%
    ml_transform(image_data$test) %>%
    dplyr::compute()
  print("Predictions vs. labels:")
  predictions %>%
    dplyr::select(!!label_col, !!prediction_col) %>%
    print(n = sdf_nrow(predictions))
  print("Accuracy of predictions:")
  predictions %>%
    ml_multiclass_classification_evaluator(
      label_col = label_col,
      prediction_col = prediction_col,
      metric_name = "accuracy"
    ) %>%
      print()

  model
}
