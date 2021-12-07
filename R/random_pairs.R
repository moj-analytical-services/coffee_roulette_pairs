utils::globalVariables(c("P1", "P2"))

#' Generate all possible unique random pairs from a set of names, with unwanted pairs removed.
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
    
    # Reverse the unwanted pairs and merge them with the unreversed ones
    ruwp <- dplyr::rename(unwantedpairs, P2 = P1, P1 = P2)
    uwp <- dplyr::bind_rows(unwantedpairs, ruwp)
    
    # Remove the unwanted pairs
    pairs <- dplyr::anti_join(pairs, uwp, by=c("P1", "P2"))
  }
  
  # Randomise the pairs
  rpairs <- dplyr::slice_sample(pairs, n = nrow(pairs))
  
  return(rpairs)
  
}

#' Clean the random pairs of names to ensure each name only appears once.
#'
#' @param rpairs A two column data frame containing pairs of names as strings on each row.
#'
#' @return A data frame.
#' @export
#'
clean_random_pairs <- function(rpairs){
  
  # Add the first pair in rpairs to the clean_rpairs
  clean_rpairs <- dplyr::slice_head(rpairs)
  
  # Going though each pair in rpairs, only add it to the store if each name in 
  # the pair is not present in any pair already in the store
  for (i in seq(nrow(rpairs))){
    
    if ((!rpairs$P1[i] %in% clean_rpairs$P1) & (!rpairs$P1[i] %in% clean_rpairs$P2) & (!rpairs$P2[i] %in% clean_rpairs$P1) & (!rpairs$P2[i] %in% clean_rpairs$P2)) {
      
      clean_rpairs <- dplyr::bind_rows(clean_rpairs, rpairs[i,1:2])
    }
    
  }
  
  return(clean_rpairs)
  
}

#' From a list of names, and unwanted pairs of names if required, generate random pairs, 
#' and save them to a collection of unwanted pairs to be avoided in future.
#'
#' @param names_file Path to a file containing a list of names in a single column.
#' @param unwantedpairs_file Path to a file containing a list of unwanted pairs, with
#' one name per column.
#'
#' @return Writes a csv file containing random pairs of names, and appends to or creates a file 
#' containing unwanted pairs.
#' @export
#'
#' @examples \dontrun{
#' random_pairs(filename = 'names.csv', unwantedpairs = 'unwantedpairs.csv')
#'}
main <- function(names_file, unwantedpairs_file = NULL){
  
  # Error handling for NULL file names
  if(is.null(names_file)){
    
    stop("Error: `file` must be a string.")
  }
  
  # Import the file containing a list of names
  names <- readr::read_csv(names_file, col_names = FALSE)
  
  # If it exists, import the file containing unwanted pairs
  if (!is.null(unwantedpairs_file)) {
    
    uwp <- readr::read_csv(unwantedpairs_file, col_names = c("P1", "P2"))
  }
  
  else{
    
    uwp <- NULL
  }
  
  # Generate the random pairs
  rpairs <- generate_random_pairs(names, uwp)
  
  # Ensure each name appears only once in the list of pairs
  clean_rpairs <- clean_random_pairs(rpairs)
  
  # Write pairs to a file
  readr::write_csv(clean_rpairs, "randompairs.csv", col_names = FALSE)
  
  if (!is.null(unwantedpairs_file)) {
    # Append the pairs to a file containing unwanted pair
    readr::write_csv(clean_rpairs, unwantedpairs_file, append = TRUE)
  } 
  else{
    readr::write_csv(clean_rpairs, "unwantedpairs.csv", append = TRUE)
  }

}

  