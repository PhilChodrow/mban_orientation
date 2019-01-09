library(keras)
library(hdf5r)

# Get the .h5 file
get_skin_data = function(h5_file_path) {
  # Takes the h5 file path, reads in the H5 file, gets the data into the
  # expected row-major format with the axes in the correct order and returns
  # it to the user
  #
  # Args:
  #   h5_file_path = File path to skin_data.h5
  #
  # Returns:
  #   A list containing X_train, y_train, and X_test
  
  # Read in the h5 file
  f = H5File$new(h5_file_path, mode="r")
  
  # Extract the data from the h5 file
  train_samples = f[["X_train"]]$maxdims[4]
  test_samples = f[["X_test"]]$maxdims[4]
  X_train = f[["X_train"]][, , , 1:train_samples]
  X_test = f[["X_test"]][, , , 1:test_samples]
  y_train = f[["y_train"]][1:train_samples]
  
  # Convert the X_train and X_test into row-major format with the expected
  # row orientation (this might take a bit of time)
  width = f[["X_train"]]$maxdims[2]
  height = f[["X_train"]]$maxdims[3]
  channels = f[["X_train"]]$maxdims[1]
  X_train = array_reshape(X_train, dim=c(train_samples, height, width, channels))
  X_test = array_reshape(X_test, dim=c(test_samples, height, width, channels))
  
  return(list("X_train"=X_train, "y_train"=y_train, "X_test"=X_test))
}
