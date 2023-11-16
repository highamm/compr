## November 30

1. Give warning use `warning("this is a warning message")` when `ref_player` does not exist.

2. Add more tests for other types of models.

## November 16

Options:

1. Make basketball home court advantage into a vignette.

2. Look into function testing with testthat.



## For November 9

1. Clean-up file structure.

2. Fix augment()

  ## stacking og_data and newdata (to make a larger data frame)
  ## using build_mat_model() to get a new model matrix
  ## getting rid of the first n rows corresponding to og_data
  ## augment on comp_mod with the results from build_mat_model()

3. Make plot again with output from new augment function.

4. Options: add gaussian linear model and/or compare two home court advantage models. 

## For November 2

1. Clean-up code.

2. Document functions and data.

3. Make plot again with output from new augment function.

4. Options: add gaussian linear model and/or compare two home court advantage models. 


## For October 26

1. See sheet for finishing augment() part.

2. MH: look into intercept component.

## For October 19

1. Finish `predict_comp()` function.

2. Look into using home court advantage as a predictor. Look at tennis serving example for analogous analysis.

3. Standard Error or Confidence Interval Bars.

## For October 5

1. MH: Test `augment()`

2. Standard Error or Confidence Interval Bars

3. Look into using home court advantage as a predictor. Look at tennis serving example for analogous analysis.

## For September 28

1. Make data frame that is 31 rows and 2 columns to use in `augment()`

2. Make lollipop plot with data frame from (1).

3. Put (1) and (2) into a function with a model argument and a "player_of_interest" argument.

4. If time, construct error bars.

5. MH: look into error bars.

## For September 21

1. Write function using `augment()` with prediction data.

2. Modify plot to include error bars.

## For September 14

1. Create lollipop plot for one team's match up win probability with all other teams (create a static plot for one single team, not yet thinking about putting it into a function).

2. Might look into a couple of other r package chapters.
