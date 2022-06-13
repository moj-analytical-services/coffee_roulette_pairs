utils::globalVariables(c("P1", "P2"))

#' Generate all possible unique random pairs from a set of names, with unwanted pairs removed, if required
#'
#' @param names A vector containing names as strings.
#' @param unwantedpairs A two column data frame containing unwanted pairs of names as strings.
#'
#' @return The function returns a two column data frame of random pairs of names as strings.
#' @export
#'
generate_random_pairs <- function(names, unwantedpairs = NULL){
  
  # Generate all unique pairs
  pairs <- tibble::tibble("P1" = t(utils::combn(t(names), 2))[,1], "P2" = t(utils::combn(t(names), 2))[,2])
  
  # Remove unwanted pairs, if required
  if (!is.null(unwantedpairs)) {
    
    # Reverse the unwanted pairs
    ruwp <- dplyr::rename(unwantedpairs, P2 = P1, P1 = P2)
    # Bind them with the unreversed ones
    uwp <- dplyr::bind_rows(unwantedpairs, ruwp)
    # Remove the unwanted pairs from the generated pairs
    pairs <- dplyr::anti_join(pairs, uwp, by=c("P1", "P2"))
  }
  
  # Randomise the pairs
  rpairs <- dplyr::slice_sample(pairs, n = nrow(pairs))
  
  return(rpairs)
  
}