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
#' @param formula
#' @param data
#' @param p1
#' @param p2
#' @param p1_effects
#' @param p2_effects
#' @param ref_player
#' @param family
#'
#' @export

comp_glm <- function(formula, data, p1, p2, p1_effects = ~ 1, p2_effects = ~ 1, ref_player = NULL, family = "binomial"){
  mat_list <- build_model_mat(formula, data, p1, p2, p1_effects, p2_effects, ref_player)
  model_out <- fit_model(mat_list, family = family)
  model_out
}

