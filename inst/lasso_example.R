library(glmnet)
?glmnet
full_matrix <- cbind(response_matrix, model_matrix_nocomp, comp_matrix_full)
matrix_for_glm <- full_matrix[stats::complete.cases(full_matrix), ] |>
  as.matrix()
test_lasso <- glmnet(x = matrix_for_glm[ ,-1],
                     y = matrix_for_glm[ ,1], intercept = FALSE,
                     alpha = 1, family = "binomial", lambda = 0.001)
coef(test_lasso)
