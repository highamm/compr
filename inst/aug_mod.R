#' Augment a paired competition model with new data
#'
#' This function extends a paired competition model with new data, returning the augmented results.
#
#' @param newdata a data frame containing new data to be added to the original data used to build the model.
#' @param comp_mod a paired competition model object.
#' @return an augmented data frame with the results of the paired competition model extended with the new data.
#' @examples
#' # Create a paired competition model comp_mod using your data and formula
#' # Define new data in the data frame newdata
#' augmented_model <- aug_mod(newdata, comp_mod)
#'
#' @export

aug_mod <- function(newdata, comp_mod){
  new_bound_df <- bind_rows(comp_mod[["data"]], newdata)
  mat_list <- build_model_mat(formula = comp_mod[["formula_str"]],
                              data = new_bound_df,
                              p1 = comp_mod[["p1"]],
                              p2 = comp_mod[["p2"]],
                              p1_effects = comp_mod[["p1_effects"]],
                              p2_effects = comp_mod[["p2_effects"]],
                              ref_player = comp_mod[["ref_player"]])
  full_matrix <- mat_list[["full_matrix"]]
  # FIXME not sure why there was an unknown column
  full_matrix <- full_matrix %>% select(-3)
  aug_df <- full_matrix %>% tail(nrow(full_matrix)-nrow(comp_mod[["data"]]))
  aug_mod <- augment(comp_mod, newdata = aug_df)
}
