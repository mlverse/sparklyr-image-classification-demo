# Overview

This package is a `sparklyr` extension containing all required MVN dependencies
and train+test data sets for a `sparklyr` image classification demo.

The goal of this demo is to leverage Apache Spark and Inception V3 (a pre-
trained convolutional neural network for image analysis tasks) to build a
scalable Spark ML pipeline capable of classifing images of cats and dogs
accurately and efficiently.

The author of this package wishes to acknowledge that the abovementioned `sparklyr`
image classification demo benefited greatly from the availability of the
[spark-deep-learning](https://spark-packages.org/package/databricks/spark-deep-learning)
library (an open-source Scala library developed by [Databricks](https://databricks.com/)
implementing Inception-V3 and other sophisticated image feature extractors) and the
[dogs-vs-cats](https://www.kaggle.com/c/dogs-vs-cats) image data set (hosted by
[Kaggle](https://www.kaggle.com/)).

# Example usage

```
library(sparklyr)
library(sparklyr.deeperer)

# NOTE: the correct spark_home path to use depends on the configuration of the
# Spark cluster you are working with.
spark_home <- "/usr/lib/spark"

sc <- spark_connect(master = "yarn", spark_home = spark_home)

run_demo(sc)
```

# Naming

The name of this R package was inspired by the title of
[this paper](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43022.pdf).
