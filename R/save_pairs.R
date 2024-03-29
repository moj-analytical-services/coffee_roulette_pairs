#' From a list of names, and unwanted pairs of names if required, generate unique random pairs, 
#' and save them to a list of unwanted pairs to be avoided in future.
#'
#' @param names_file Path to a file containing a list of names in a single column.
#' @param unwantedpairs_file Path to a file containing a list of unwanted pairs, with
#' one name per column.
#' @param no_of_tries Integer. The number of times to re-randomize and generate a round of pairs,
#' if insufficent have been generated.
#'
#' @return Writes a csv file containing random pairs of names, and appends to or creates a file 
#' containing unwanted pairs.
#' @export
#'
#' @examples \dontrun{
#' save_pairs(names_file = 'names.csv', unwantedpairs_file = 'unwantedpairs.csv')
#'}
save_pairs <- function(names_file=NULL, unwantedpairs_file = NULL, no_of_tries = 20){
  
  # Error handling for NULL file names
  if(is.null(names_file)){
    
    stop("The path to a csv file containing the list of names must be provided.")
  } 
  
  if(!file.exists(names_file)){
    stop(paste0('No file was found at the following path: ', names_file))
  } else{
    message('The following path was given for the file containing the names of participants: "', names_file, '"')
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
    message(paste0('Since an odd number of names was provided (', length(names), '), 1 person will not be matched (given no one should be matched more than once).'))
  }
  
  # If it exists, import the file containing unwanted pairs
  if (!is.null(unwantedpairs_file)) {
    
    if(file.exists(unwantedpairs_file)){
      uwp <- readr::read_csv(unwantedpairs_file, col_names = c("P1", "P2"), col_types = 'cc')
      message(paste0('The following path was provided for the file containing unwanted pairs: "', unwantedpairs_file, '", which contains ', nrow(uwp), ' pair(s).'))
    }
    else{
      message(paste0('No unwanted pairs file was found at the following path: "', unwantedpairs_file, '"'))
    }
  }
  else{
    uwp <- NULL
    message('No unwanted pairs file was provided.')
  }
  
  # Re-randomize pairs until sufficient pairs to ensure everyone is matched is achieved
  for(i in 1:no_of_tries){
    
    # Generate all random pairs, with the unwanted pairs removed
    rpairs <- generate_random_pairs(names, uwp)
    
    # Ensure each name appears only once in the random pairs
    clean_rpairs <- clean_random_pairs(rpairs)
    
    if (nrow(clean_rpairs) == n_unique_pairs){
      message('Sufficiently many random pairs have been generated for every one to have a match (for an even number of names).')
      break
    }
  }
  
  if(nrow(clean_rpairs) < n_unique_pairs){
    stop(paste0(
    'After ', no_of_tries, ' attempts, an insufficient number of random pairs has been generated for everyone to have a match. 
    This is due to the number of unwanted pairs provided constraining the number of combinations available to build a round where everyone appears only once. 
    Please try running the function again to see if sufficient pairs are generated, or alternatively remove some unwanted pairs.'))
  }
  
  # Write pairs to a file
  readr::write_csv(clean_rpairs, "randompairs.csv", col_names = FALSE)
  
  message('These random pairs have been written to "randompairs.csv"')
  
  # Update unwanted pairs with the matched pairs, and write to file
  uwp <- dplyr::bind_rows(uwp, clean_rpairs)
  
  # Append the pairs to a file containing unwanted pairs
  if (!is.null(unwantedpairs_file)) {
    readr::write_csv(uwp, unwantedpairs_file, col_names = FALSE)
    message(paste0('The newly matched pairs were added to "', unwantedpairs_file, '", which now contains ', nrow(uwp), ' pairs.'))
  } 
  else{
    readr::write_csv(clean_rpairs, "unwantedpairs.csv", col_names = FALSE)
    message('The newly matched pairs were added to a new unwanted pairs file called "unwantedpairs.csv".')
  }
  
}
