#' Fit a paired competition generalized linear model (GLM)
#'
#' This function fits a competition model using the model matrix components
#' prepared by `build_model_mat`. It allows you to specify additional arguments
# for the GLM.
#
#' @param mat_list a list containing the model matrix components as generated
#' by the `build_model_mat` function.
#' @param ... additional arguments to be passed to the glm function (e.g., family).
#' @return a fitted model object of class "glm" and "lm" with competition modeling results.
# @examples
#' comp_glm(point_winner ~ atp_importance, data = tennis_point,
#'       p1 = "player1", p2 = "player2",
#'       p1_effects = ~ point_server1, p2_effects = ~ point_server2,
#'       ref_player = "Milos Raonic", family = binomial)
#'
#' @param mat_list
#' @param family
#'
#' @export

fit_model <- function(mat_list, family){

  df_for_glm <- mat_list[["full_matrix"]][stats::complete.cases(mat_list[["full_matrix"]]), ] #|> as.matrix()

  response_column <- colnames(df_for_glm)[1]

  og_formula <- paste(response_column, "~ . -", response_column,
                      "- ", 1) ## drops second intercept

  formula_obj <- as.formula(og_formula)

  # Use the formula object in glm
  model_out <- stats::glm(formula_obj, data = df_for_glm, family = family)
  model_out$ref_player <- mat_list[["ref_player"]]
  model_out$og_data <- mat_list[["data"]]
  model_out$p1 <- mat_list[["p1"]]
  model_out$p2 <- mat_list[["p2"]]
  model_out$p1_effects <- mat_list[["p1_effects"]]
  model_out$p2_effects <- mat_list[["p2_effects"]]
  model_out$og_formula <- mat_list[["og_formula"]]
  model_out
}
