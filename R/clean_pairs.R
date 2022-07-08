#' Clean the random pairs of names to ensure each name only appears once.
#'
#' @param rpairs A two column data frame containing pairs of names as strings on each row.
#'
#' @return A data frame.
#' @export
#'
clean_random_pairs <- function(rpairs){
  
  # Add the first pair in rpairs to the clean_rpairs
  cleaned_rpairs <- dplyr::slice_head(rpairs)
  
  # Going though each pair in rpairs, only add it to the store if each name in
  # the pair is not present in any pair already in the store
  for (i in seq(nrow(rpairs))){

    if ((!rpairs$P1[i] %in% cleaned_rpairs$P1) & (!rpairs$P1[i] %in% cleaned_rpairs$P2) & (!rpairs$P2[i] %in% cleaned_rpairs$P1) & (!rpairs$P2[i] %in% cleaned_rpairs$P2)) {

      cleaned_rpairs <- dplyr::bind_rows(cleaned_rpairs, rpairs[i,1:2])
    }

  }
  message(paste0(nrow(cleaned_rpairs), ' pairs remain after ensuring each name only appears once.'))
  
  return(cleaned_rpairs)
  
}