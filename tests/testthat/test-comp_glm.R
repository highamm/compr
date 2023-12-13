test_that("model fits", {
  expect_no_error(comp_glm(point_winner ~ -1, data = tennis_point,
                           p1 = "player1", p2 = "player2",
                           p1_effects = ~ 1, p2_effects = ~ 1,
                           ref_player = "Milos Raonic"))
})

test_that("snapshot test for comp_glm", {
  comp_glm_result <- comp_glm(point_winner ~ -1, data = tennis_point,
                              p1 = "player1", p2 = "player2",
                              p1_effects = ~ 1, p2_effects = ~ 1,
                              ref_player = "Milos Raonic")
  expect_snapshot(
      comp_glm_result
  )
})

test_that("snapshot test for model with covariates", {
  comp_glm_cov_result <- comp_glm(point_winner ~ -1, data = tennis_point,
                              p1 = "player1", p2 = "player2",
                              p1_effects = ~ point_server1,
                              p2_effects = ~ point_server2,
                              ref_player = "Milos Raonic")
  expect_snapshot(
    comp_glm_cov_result
  )
})

test_that("expect warning if ref_player not in data set", {
  expect_warning({
    comp_glm(point_winner ~ -1, data = tennis_point,
             p1 = "player1", p2 = "player2",
             p1_effects = ~ 1, p2_effects = ~ 1,
             ref_player = "Nonexistent Player")
  }, "Reference player 'Nonexistent Player' not found in the dataset.")
})

# aug_mod testing
#TODO might have to do an augment test does it throw an error if the player is not in the data set
