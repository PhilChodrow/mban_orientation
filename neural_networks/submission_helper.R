library(tidyverse)

gen_submission_file = function(y_pred, id_df) {
  # Makes a valid submission file for the competition
  #
  # Args:
  #   y_pred: Vector of integers containing predictions from the model
  #   id_df: Provided DataFrame containing the test image IDs (it is assumed
  #          that you predicted the samples in the same order that they were
  #          were given otherwise your answers will be wrong)
  #
  # Returns:
  #   DataFrame that is valid for submission to the competition
  
  return(tibble(id=id_df$id, prediction=y_pred))
}
