#' Tennis Match Data
#'
#' A data set containing tennis matches in 2023 for 8 players.
#'
#' @format A data frame with 6 variables
#' \describe{
#'   \item{winner}{a \code{1} for all matches}
#'   \item{winner_name}{the name of the winning player}
#'   \item{loser_name}{the name of the losing player}
#'   \item{age_diff}{difference in player ages (winner minus loser)}
#'   \item{ht_diff}{difference in player heights (winner minus loser)}
#'   \item{cov}{a randomly generated covariate}
#'   ...
#' }
#'
#' @examples
#' \dontrun{
#' players <- c("Carlos Alcaraz", "Daniil Medvedev", "Holger Rune",
#' "Novak Djokovic", "Jannik Sinner", "Taylor Fritz",
#' "Karen Khachanov", "Stefanos Tsitsipas")
#' tennis_match <- readr::read_csv("https://raw.githubusercontent.com/JeffSackmann/tennis_atp/master/atp_matches_2023.csv") |>
#'   dplyr::filter(winner_name %in% players &
#'                  loser_name %in% players) |>
#'  dplyr::select(winner_name, loser_name, winner_age, loser_age,
#'         winner_ht, loser_ht) |>
#'  dplyr::mutate(age_diff = winner_age - loser_age,
#'         ht_diff = winner_ht - loser_ht,
#'         winner = rep(1, length(winner_age)),
#'         cov = rnorm(length(winner_age), 0, 1)) |>
#'  dplyr::select(winner, winner_name, loser_name, age_diff, ht_diff, cov)
#'  save(tennis_match, file = "data/tennis_match.rda")
#' }
"tennis_match"

#' Tennis Point Data
#'
#' A data set containing point-level data for men's singles matches
#' at Wimbledon from 2017 through 2021. Only matches from the 4th round
#' onward are included.
#'
#' @format A data frame with 9 variables
#' \describe{
#'   \item{player1}{the name of the first player}
#'   \item{player2}{the name of the second player}
#'   \item{point_winner}{a \code{1} if the first player won the point and a \code{0} if the second player won the point}
#'   \item{atp_importance}{the importance of the point}
#'   \item{match_num}{a match identification number}
#'   \item{year}{the year the match was played in}
#'   \item{slam}{the slam (\code{wimbledon} for all of these matches)}
#'   \item{point_server1}{a \code{1} if the server was \code{player1}, and a \code{0} otherwise}
#'   \item{point_server2}{a \code{1} if the server was \code{player2}, and a \code{0} otherwise}
#'   ...
#' }
#'
#' @examples
#' \dontrun{
#' tennis_point <- readr::read_csv("inst/extra_data/test_data_serving.csv") |>
#'  dplyr::mutate(point_server1 = point_server,
#'         point_server2 = dplyr::if_else(point_server == 0,
#'                                 true = 1, false = 0)) |>
#'  dplyr::select(-point_server)
#' save(tennis_point, file = "data/tennis_point.rda")
#' }
"tennis_point"


#' Tennis Point Data WTA
#'
#' A data set containing point-level data for women's singles matches
#' at Wimbledon and the U.S. Open from 2017 through 2021.
#' Only matches from the 4th round onward are included.
#'
#' @format A data frame with 9 variables
#' \describe{
#'   \item{player1}{the name of the first player}
#'   \item{player2}{the name of the second player}
#'   \item{point_winner}{a \code{1} if the first player won the point and a \code{0} if the second player won the point}
#'   \item{atp_importance}{the importance of the point}
#'   \item{match_num}{a match identification number}
#'   \item{year}{the year the match was played in}
#'   \item{slam}{the slam (\code{wimbledon} or \code{usopen})}
#'   \item{point_server1}{a \code{1} if the server was \code{player1}, and a \code{0} otherwise}
#'   \item{point_server2}{a \code{1} if the server was \code{player2}, and a \code{0} otherwise}
#'   ...
#' }
#'
#' @examples
#' \dontrun{
#' tennis_point_wta <- readr::read_csv("inst/extra_data/test_data_serving_wta.csv") |>
#'  dplyr::mutate(point_server1 = point_server,
#'         point_server2 = dplyr::if_else(point_server == 0,
#'                                 true = 1, false = 0)) |>
#'  dplyr::select(-point_server)
#' save(tennis_point_wta, file = "data/tennis_point_wta.rda")
#' }
"tennis_point_wta"



#' Toy Competition Data
#'
#' A data set with simulated competition data.
#'
#' @format A data frame with 9 variables
#' \describe{
#'   \item{contest_winner}{a \code{1} if \code{player1} won the contest and a \code{0} if \code{player2} won the contest}
#'   \item{player1}{a vector of players}
#'   \item{player2}{a vector of competing players}
#'   \item{player1_quant}{a quantitative player-level covariate for \code{player1}}
#'   \item{player2_quant}{a quantitative player-level covariate for \code{player2}}
#'   \item{player1_fact}{a categorical player-level covariate for \code{player1}}
#'   \item{player2_fact}{a categorical player-level covariate for \code{player2}}
#'   \item{contest_fact}{a categorical contest-level covariate}
#'   \item{contest_quant}{a quantitative contest-level covariate}
#'   ...
#' }
#'
#' @examples
#' \dontrun{
#' set.seed(05052023)
#' player1 <- sample(c("A", "B", "C", "D"), size = 150, replace = TRUE)
#' player2 <- sample(c("A", "B", "C", "D"), size = 150, replace = TRUE)
#' keep_ind <- player1 != player2
#' player1 <- player1[keep_ind]
#' player2 <- player2[keep_ind]
#' n <- length(player1)
#' contest_fact <- sample(c("Venue 1", "Venue 2", "Venue 3"), size = n,
#'                        replace = TRUE)
#' contest_quant <- runif(n, 0, 1)
#' player1_fact <- sample(c("W", "X", "Y", "Z"), size = n, replace = TRUE)
#' player2_fact <- sample(c("W", "X", "Y", "Z"), size = n, replace = TRUE)
#' player1_quant <- rnorm(n, 20, 2)
#' player2_quant <- rnorm(n, 20, 2)
#' contest_winner <- rbinom(n, size = 1, prob = 0.54)
#' toy_comp <- tibble::tibble(contest_winner, player1, player2,
#'                            player1_quant, player2_quant,
#'                            player1_fact, player2_fact,
#'                            contest_fact, contest_quant)
#' save(toy_comp, file = "data/toy_comp.rda")
#' }
"toy_comp"


#' NBA Game Data
#'
#' A dataset containing information about NBA games, including details about the date, teams (away and home), points scored by each team, whether the game went into overtime, and the outcome (home team winner).
#'
#' @format A data frame with 8 variables
#' \describe{
#'   \item{date}{the date of the game}
#'   \item{away}{the name of the away team}
#'   \item{away_pts}{points scored by the away team}
#'   \item{home}{the name of the home team}
#'   \item{home_pts}{points scored by the home team}
#'   \item{OT}{a logical indicating whether the game went into overtime}
#'   \item{home_winner}{a logical indicating whether the home team won the game}
#'   \item{pts_diff}{the point difference between the home and away teams}
#'   \item{home_court_1}{a binary indicator for home team (1 for home team, 0 otherwise)}
#'   \item{home_court_2}{a binary indicator for home team (1 for home team, 0 otherwise)}
#'   ...
#' }
#'
#' @examples
#' \dontrun{
#'   # TODO what do I add here
#'   nba_game <- readr::read_csv("path/to/nba_game_data.csv")
#' }
"nba_game"



