#' Fit a paired competition generalized linear model
#'
#' Fit a competition model with either contest-level fixed effects
#' or player-level fixed effects.
#'
#' @param formula an object of class \code{"formula"}. \code{formula}
#'  should be a two-sided formula with the numeric response variable on
#'   the left-hand side and contest-level predictors on the right-hand
#'   side.
#' @param data a data frame with variables to fit the model
#' @param p1 a string with the name of the column of \code{data} with
#' the first player.
#' @param p2 a string with the name of the column of \code{data} with
#' the second player.
#' @param p1_effects a one-sided \code{"formula"} object giving
#' player-level effects for the first player.
#' @param p2_effects a one-sided \code{"formula"} object giving
#' player-level effects for the second player.
#' @param ref_player a string giving the reference player
#' @return a fitted model object of class \code{"glm"} and \code{"lm"}
#' @examples
#' comp_glm(point_winner ~ atp_importance, data = tennis_point,
#'       p1 = "player1", p2 = "player2",
#'       p1_effects = ~ point_server1, p2_effects = ~ point_server2,
#'       ref_player = "Milos Raonic")
#'
#' comp_glm(point_winner ~ -1, data = tennis_point,
#'     p1 = "player1", p2 = "player2",
#'     p1_effects = ~ 1, p2_effects = ~ 1,
#'     ref_player = "Milos Raonic")
#'
#' comp_glm(formula = point_winner ~ -1, data = tennis_point_wta,
#'     p1 = "player1", p2 = "player2",
#'     p1_effects = ~ 1, p2_effects = ~ 1,
#'     ref_player = "Angelique Kerber")
#'
#' comp_glm(formula = contest_winner ~ contest_quant + contest_fact,
#'    data = toy_comp,
#'    p1 = "player1", p2 = "player2",
#'    p1_effects = ~ player1_fact,
#'    p2_effects = ~ player2_fact)
#'
#' @import dplyr
#' @importFrom stats model.frame
#' @importFrom stats model.matrix
#' @export

comp_glm <- function(formula, data, p1, p2,
                     p1_effects = ~ 1, p2_effects = ~ 1,
                     ref_player = NULL) {


  model_frame_nocomp <- model.frame(formula, na.action =
                                             stats::na.pass, data = data)
  model_matrix_nocomp <- model.matrix(formula,
                                             model.frame(formula, data,
                                na.action = stats::na.pass))

  ## model.response(model_frame_nocomp, type = "numeric") |> matrix
  response_matrix <- model_frame_nocomp[ ,1 , drop = FALSE]

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

  matrix_for_glm <- full_matrix[stats::complete.cases(full_matrix), ] |>
    as.matrix()

  model_out <- stats::glm(matrix_for_glm[ ,1] ~ -1 + matrix_for_glm[ ,-1],
                   family = "binomial")
  names(model_out$coefficients) <- names(full_matrix)[-1]
  model_out
}
