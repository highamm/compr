#' Replace values in a vector at certain indices with a 1 and -1
#'
#' @param vec is a vector
#' @param players is a vector of strings (players) the same length as vec
#' @param player1 is a string that gives the index that should take on a 1
#' @param player2 is a string that gives the index that should take on a -1
#' @param val1 is a value assigned to the index of \code{player1}
#' @param val2 is a value assigned to the index of \code{player2}
#' @return a vector with a 1 and -1 replacing two of the original values
#' @examples
#' vec <- rep(0, 3)
#' players <- c("A", "B", "C")
#' get_data_vec(vec, players, "A", "C")
#' @export

get_data_vec <- function(vec, players, player1, player2,
                         val1 = 1, val2 = 1) {
  vec[players == player1] <- val1
  vec[players == player2] <- -1 * val2
  vec
}

#' create a design matrix with 0's, 1's, and -1's.
#'
#' @param vec is a vector of 0's
#' @param players is a vector of strings (players) the same length as vec
#' @param player1_vec is a vector of "player" 1's
#' @param player2_vec is a vector of "player" 2's
#' @param val1 is a value assigned to the index of \code{player1}
#' @param val2 is a value assigned to the index of \code{player2}
#' @param names is an optional vector of names given to the columns of the
#' returned matrix.
#' @return a matrix with the number of rows equal to the length of player1_vec and the number of columns equal to the length of players. Each row contains a single 1 (corresponding to player 1 for that row) and a single -1 (corresponding to player 2 for that row).
#' @examples
#' vec <- rep(0, 3)
#' players <- c("A", "B", "C")
#' player1 <- c("A", "B")
#' player2 <- c("C", "A")
#' create_d_mat(vec, players, player1, player2, val1 = c(1, 1), val2 = c(1, 1))
#' @export


create_d_mat <- function(vec, players, player1_vec, player2_vec,
                         val1 = 1, val2 = 1, names = NULL) {

  list_out <- purrr::pmap(list(player1 = player1_vec,
                               player2 = player2_vec,
                               val1 = val1,
                               val2 = val2),
                          get_data_vec, vec = vec, players = players)
  out <- matrix(list_out |> unlist(),
                ncol = length(players), byrow = TRUE)

  if (sum(val1[!is.na(val1)]) == length(val1[!is.na(val1)])) {
    colnames(out) <- players
  } else {

    colnames(out) <- paste(players, names,
                           sep = "_")
  }
  rownames(out) <- NULL

  return(out)
}

