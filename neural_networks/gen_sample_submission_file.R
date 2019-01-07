source("c:/devspace/mycode/cos2019/dl_course/submission_helper.R")

# Get the Test ID DataFrame
id_df = read_csv("c:/devspace/mycode/cos2019_data/test_ids.csv")

# Generate random predictions
n = nrow(id_df)
set.seed(59)
y_pred = sample(1:7, size=n, replace=T)

# Get an example submission file
ex_submission = gen_submission_file(y_pred, id_df)

# Write the submission to disk
write_csv(ex_submission, 
          "c:/devspace/mycode/cos2019_data/example_submission.csv")


# Write a submission where we just make predictions of all one
all_one = rep(1, n)
sandbox_submission = gen_submission_file(all_one, id_df)
write_csv(sandbox_submission,
          "c:/devspace/mycode/cos2019_data/sandbox_submission.csv")
