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
save_pairs <- function(names_file=NULL, unwantedpairs_file = NULL){
  
  # Error handling for NULL file names
  if(is.null(names_file)){
    
    stop("The path to a csv file containing the list of names must be provided.")
  } 
  
  if(!file.exists(names_file)){
    stop(paste0('No file was found at the following path: ', names_file))
  } else{
    message('The names file will be imported using the following path: "', names_file, '"')
  }
  
  # Import the file containing a list of names
  names <- dplyr::pull(readr::read_csv(names_file, col_names = FALSE, col_types = 'c'))
  
  # Number of unique pairs it's possible to generate
  n_unique_pairs <- floor(length(unique(names))/2)
  
  # Check if duplicate names were provided
  if (length(unique(names)) < length(names)){
    # Number of names that are not unique
    duplicates <- length(names) - length(unique(names))
    warning(paste0(duplicates, ' duplicate name(s) provided in the names file out of ', length(names), ' names, so only ', n_unique_pairs, ' unique random pairs can be generated.'))
  } 
  else{
    message('The names file provided contains ', length(names), ' unique names, meaning ', n_unique_pairs, ' unique pairs can be generated.')
  }
  
  # Print warning if an odd number of names provided
  if(length(names) %% 2 != 0){
    message(paste0('A odd number of names was provided (', length(names), '), so 1 person will not be matched (given no one should be matched more than once).'))
  }
  
  # If it exists, import the file containing unwanted pairs
  if (!is.null(unwantedpairs_file)) {
    
    if(file.exists(unwantedpairs_file)){
      uwp <- readr::read_csv(unwantedpairs_file, col_names = c("P1", "P2"), col_types = 'cc')
      message(paste0('Unwanted pairs were imported from the following path: "', unwantedpairs_file, '" containing ', nrow(uwp), ' pair(s).'))
    }
    else{
      message(paste0('No unwanted pairs file was found at the following path: "', unwantedpairs_file, '"'))
    }
  }
  else{
    uwp <- NULL
    message('No unwanted pairs file was provided.')
  }
  
  # Generate the random pairs
  rpairs <- generate_random_pairs(names, uwp)
  
  # Ensure each name appears only once in the list of pairs
  clean_rpairs <- clean_random_pairs(rpairs)
  
  message('These random pairs will be written to "randompairs.csv"')
  
  if(nrow(clean_rpairs) < n_unique_pairs){
    stop('Fewer unique random pairs would be written to file than it is possible to generate from the names provided, ignoring unwanted pairs. This is due to the number
    of unwanted pairs provided, constraining the number of combinations available. Please try running the function again to see if sufficient pairs are generated, 
    or alternatively remove some unwanted pairs.')
  }
  
  # Write pairs to a file
  readr::write_csv(clean_rpairs, "randompairs.csv", col_names = FALSE)
  
  # Update unwanted pairs with the matched pairs, and write to file
  uwp <- dplyr::bind_rows(uwp, clean_rpairs)
  
  # Append the pairs to a file containing unwanted pairs
  if (!is.null(unwantedpairs_file)) {
    readr::write_csv(uwp, unwantedpairs_file, col_names = FALSE)
    message(paste0('The newly matched pairs were added to the unwanted pairs file, which now contains ', nrow(uwp), ' pairs.'))
  } 
  else{
    readr::write_csv(clean_rpairs, "unwantedpairs.csv", col_names = FALSE)
    message('The newly matched pairs were added to a new unwanted pairs file called "unwantedpairs.csv".')
  }
  
}
