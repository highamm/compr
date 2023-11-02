#' Build a paired competition model matrix for generalized linear models (GLMs)
#'
#' This function prepares the model matrix required for fitting competition models
# with either contest-level fixed effects or player-level fixed effects.
#
#' @param formula an object of class "formula". It should be a two-sided formula
#'   with the numeric response variable on the left-hand side and contest-level
#'   predictors on the right-hand side.
#' @param data a data frame with variables used to fit the model.
#' @param p1 a string with the name of the column in the data frame that corresponds
#'   to the first player.
#' @param p2 a string with the name of the column in the data frame that corresponds
#'   to the second player.
#' @param p1_effects a one-sided formula object specifying player-level effects for
#'   the first player.
#' @param p2_effects a one-sided formula object specifying player-level effects for
#'   the second player.
#' @param ref_player a string representing the reference player.
# @param ... additional arguments to be passed to the model frame and model matrix
#' functions.
#' @return a list containing the model matrix components needed for competition modeling.
#' @examples
#' build_model_mat(point_winner ~ atp_importance, data = tennis_point,
#'       p1 = "player1", p2 = "player2",
#'       p1_effects = ~ point_server1, p2_effects = ~ point_server2,
#'       ref_player = "Milos Raonic")
#'
#' build_model_mat(point_winner ~ -1, data = tennis_point,
#'     p1 = "player1", p2 = "player2",
#'     p1_effects = ~ 1, p2_effects = ~ 1,
#'     ref_player = "Milos Raonic")
#'
#' build_model_mat(formula = point_winner ~ -1, data = tennis_point_wta,
#'     p1 = "player1", p2 = "player2",
#'     p1_effects = ~ 1, p2_effects = ~ 1,
#'     ref_player = "Angelique Kerber")
#'
#' @import dplyr
#' @importFrom stats model.frame
#' @importFrom stats model.matrix
#' @export

build_model_mat <- function(formula, data, p1, p2,
                            p1_effects = ~ 1, p2_effects = ~ 1,
                            ref_player = NULL) {
  model_frame_nocomp <- model.frame(formula, na.action =
                                      stats::na.pass, data = data)
  model_matrix_nocomp <- model.matrix(formula,
                                      model.frame(formula, data,
                                                  na.action = stats::na.pass))

  ## model.response(model_frame_nocomp, type = "numeric") |> matrix
  response_matrix <- model_frame_nocomp[ ,1 , drop = FALSE]
  #browser()
  player1_vec <- data |> dplyr::pull(p1)
  player2_vec <- data |> dplyr::pull(p2)

  players_unique <- c(player1_vec,
                      player2_vec) |>
    unique()

  p1_mat <- model.matrix(p1_effects,
                         model.frame(p1_effects, data,
                                     na.action = stats::na.pass))

  p2_mat <- model.matrix(p2_effects,
                         model.frame(p2_effects, data,
                                     na.action = stats::na.pass))


  p1_mat_split <- lapply(seq_len(ncol(p1_mat)),
                         function(x) p1_mat[ , x])
  names(p1_mat_split) <- colnames(p1_mat)

  p2_mat_split <- lapply(seq_len(ncol(p2_mat)),
                         function(x) p2_mat[ , x])
  names(p2_mat_split) <- colnames(p2_mat)


  model_matrix_list <- purrr::pmap(list(val1 = p1_mat_split,
                                        val2 = p2_mat_split,
                                        names = p1_mat_split |> names()),
                                   create_d_mat,
                                   vec = rep(0, length(players_unique)),
                                   players = players_unique,
                                   player1_vec = player1_vec,
                                   player2_vec = player2_vec)

  comp_matrix_full <- do.call(cbind, model_matrix_list)

  if (is.null(ref_player)) {
    ref_player <- players_unique[1]
  }

  comp_matrix_red <- comp_matrix_full[ ,-which(players_unique == ref_player)]


  full_matrix <- cbind(response_matrix, model_matrix_nocomp, comp_matrix_red)

  #FIXME: used this to be able to pass ref_player to fit_model
  mat_list <- list(full_matrix = full_matrix,
                   ref_player = ref_player)

}

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
#' @export


fit_model <- function(mat_list, ...){
  #FIXME: is it better practice to do the following?
  #full_matrix <- mat_list[["full_matrix"]]

  df_for_glm <- mat_list[["full_matrix"]][stats::complete.cases(mat_list[["full_matrix"]]), ] #|> as.matrix()



  response_column <- colnames(df_for_glm)[1]

  formula_str <- paste(response_column, "~ . -", response_column,
                       "- ", 1) ## drops second intercept

  formula_obj <- as.formula(formula_str)

  # Use the formula object in glm
  model_out <- stats::glm(formula_obj, data = df_for_glm,
                          family = ...)
  model_out$ref_player <- mat_list[["ref_player"]]
  model_out$og_data <- data
  model_out
}

#' Fit a paired competition generalized linear model (GLM)
#'
#' This function simplifies the process of building and fitting a competition model using
#' the provided formula and data. It uses the `build_model_mat` function to prepare
#' the necessary model matrix and the `fit_model` function to fit the GLM.
#
#' @param formula an object of class "formula". It should be a two-sided formula
#'   with the numeric response variable on the left-hand side and contest-level
#'   predictors on the right-hand side.
#' @param data a data frame with variables used to fit the model.
#' @param p1 a string with the name of the column in the data frame that corresponds
#'   to the first player.
#' @param p2 a string with the name of the column in the data frame that corresponds
#'   to the second player.
#' @param p1_effects a one-sided formula object specifying player-level effects for
#'   the first player.
#' @param p2_effects a one-sided formula object specifying player-level effects for
#'   the second player.
#' @param ref_player a string representing the reference player.
# @param ... additional arguments to be passed to the model frame and model matrix
#' functions, as well as the GLM function.
# @return a fitted model object of class "glm" and "lm" with competition modeling results.
# @examples
#' comp_glm(point_winner ~ atp_importance, data = tennis_point,
#'       p1 = "player1", p2 = "player2",
#'       p1_effects = ~ point_server1, p2_effects = ~ point_server2,
#'       ref_player = "Milos Raonic", family = binomial)
#'
#' @export

#' Fit a paired competition generalized linear model (GLM)
#'
#' This function simplifies the process of building and fitting a competition model using
#' the provided formula and data. It uses the `build_model_mat` function to prepare
#' the necessary model matrix and the `fit_model` function to fit the GLM.
#
#' @param formula an object of class "formula". It should be a two-sided formula
#'   with the numeric response variable on the left-hand side and contest-level
#'   predictors on the right-hand side.
#' @param data a data frame with variables used to fit the model.
#' @param p1 a string with the name of the column in the data frame that corresponds
#'   to the first player.
#' @param p2 a string with the name of the column in the data frame that corresponds
#'   to the second player.
#' @param p1_effects a one-sided formula object specifying player-level effects for
#'   the first player.
#' @param p2_effects a one-sided formula object specifying player-level effects for
#'   the second player.
#' @param ref_player a string representing the reference player.
# @param ... additional arguments to be passed to the model frame and model matrix
#' functions, as well as the GLM function.
# @return a fitted model object of class "glm" and "lm" with competition modeling results.
# @examples
#' comp_glm(point_winner ~ atp_importance, data = tennis_point,
#'       p1 = "player1", p2 = "player2",
#'       p1_effects = ~ point_server1, p2_effects = ~ point_server2,
#'       ref_player = "Milos Raonic", family = binomial)
#'
#' @export

comp_glm <- function(formula, data, p1, p2, p1_effects = ~ 1, p2_effects = ~ 1, ref_player = NULL, ...){
  mat_list <- build_model_mat(formula, data, p1, p2, p1_effects, p2_effects, ref_player)
  model_out <- fit_model(mat_list, ...)
  model_out
}

