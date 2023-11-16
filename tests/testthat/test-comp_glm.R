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
    waldo::compare(
      cat(comp_glm_result)
    )
  )
})

# tried expect_snapshot_output
#
