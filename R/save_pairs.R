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
#' save_pairs(names_file = 'names.csv', unwantedpairs_file = 'unwantedpairs.csv')
#'}
save_pairs <- function(names_file, unwantedpairs_file = NULL){
  
  # Error handling for NULL file names
  if(is.null(names_file)){
    
    stop("Error: `file` must be a string.")
  }
  
  # Import the file containing a list of names
  names <- dplyr::pull(readr::read_csv(names_file, col_names = FALSE))
  
  # Check if duplicate names were provided
  if (length(unique(names)) < length(names)){
    duplicates <- length(names) - length(unique(names))
    n_unique_pairs <- floor(length(unique(names))/2)
    warning(paste0(duplicates, ' duplicate name provided, so only ', n_unique_pairs, ' unique random pairs will be generated'))
  }
  
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
  
  # Update unwanted pairs with the matched pairs, and write to file
  uwp <- dplyr::bind_rows(uwp, clean_rpairs)
  
  # Append the pairs to a file containing unwanted pair
  if (!is.null(unwantedpairs_file)) {
    readr::write_csv(uwp, unwantedpairs_file, col_names = FALSE)
  } 
  else{
    readr::write_csv(clean_rpairs, "unwantedpairs.csv", col_names = FALSE)
  }
  
}
