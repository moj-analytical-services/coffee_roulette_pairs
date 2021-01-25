utils::globalVariables(c("P1", "P2"))


#' Randomly pair up a group of people
#'
#' Given a list of people's names, pair them up with each other randomly so that each person appears once, and write the
#' pairs to a file. Also, append these pairs to an additional file, so that they won't be matched
#' again if the function is rerun.
#'
#' @param filename csv file containing the list of people's names.
#' @param unwantedpairs csv file containing pairs of names which you don't want to appear the next time the function is run.
#'
#' @return The function returns nothing, but saves a csv file containing the list of random pairs called `Round.csv`, and a csv
#' file called `unwantedpairs.csv` containing pairs which you don't want to appear in future.
#'
#' @examples
#' \dontrun{
#' random_pairs(filename = 'names.csv', unwantedpairs = 'unwantedpairs.csv')
#'}
#'
#' @export

random_pairs <- function(filename = NULL, unwantedpairs = NULL){
  
  # Check filename and unwantedpairs are provided as strings
  if (is.null(filename)) {
    stop("Please supply the path to the csv file containing the list of coffee roulette participants")
  }
  
  tryCatch(is.character(filename),
           error = function(err){
             err$message <- paste("Please provide the name of the csv file containing the list of coffee roulette participants as a string")
             stop(err)
           }
  )
  
  if (!is.character(filename)) {
    stop("Please supply the the path to the csv file containing the list of coffee roulette participants as a string")
  }
  
  tryCatch(is.null(unwantedpairs) == FALSE & is.character(unwantedpairs),
           error = function(err){
             err$message <- paste("Please provide the name of the csv file containing the list of unwanted coffee roulette pairs as a string")
             stop(err)
           }
  )
  
  # Prints current working directory
  message(paste0("Your current working directory is: ", getwd(), ". 'Round.csv' will be saved there."))
  
  # Import the list of names
  names <- readr::read_csv(filename, col_names = "name")
  
  # If not of even length, remove the first name from the list
  if(nrow(names) %% 2 != 0){
    warning(paste0("An odd number of names has been provided! The first name was ignored, i.e.", names[1,1]))
    names <- dplyr::slice(names, -1)
  }
  
  # Import the list of unwanted pairs
  if (!is.null(unwantedpairs)) {
    uwp <- readr::read_csv(unwantedpairs, col_names = c("P1", "P2"))
  }
  
  ## MAIN BODY -----------------------------------------------------------------------------------------------------------
  
  # # Generate all unique pairs
  pairs <- tibble::tibble("P1" = t(utils::combn(names$name, 2))[,1], "P2" = t(utils::combn(names$name, 2))[,2])
  
  # Remove unwanted pairs, if required
  if (!is.null(unwantedpairs)) {
    
    # Reverse the unwanted pairs and merge them with the unreversed ones
    ruwp <- dplyr::rename(uwp, P2 = P1, P1 = P2)
    uwp <- dplyr::bind_rows(uwp, ruwp)
    
    # Remove the unwanted pairs
    pairs <- dplyr::anti_join(pairs, uwp, by=c("P1", "P2"))
  }
  
  # Randomise the pairs
  rpairs <- dplyr::slice_sample(pairs, n = nrow(pairs))
  
  # Add the first pair to the store
  store <- dplyr::slice_head(rpairs)
  
  # The number of pairs for a complete single round
  ppr <- nrow(names)/2
  
  # Counter for the number of pairs added to store
  k <- 1
  
  # Going though each pair in rpairs, only add it to the store if each name in the pair is not already present in any pair in the store
  for (i in seq(nrow(rpairs))){
    
    if ((!rpairs$P1[i] %in% store$P1) & (!rpairs$P1[i] %in% store$P2) & (!rpairs$P2[i] %in% store$P1) & (!rpairs$P2[i] %in% store$P2)) {
      
      store <- dplyr::bind_rows(store, rpairs[i,1:2])
      k <- k + 1
    }
    
    # If the number of pairs for a complete round have been stored, write out the pairs, and break the loop
    if (k == ppr){
      
      readr::write_csv(store, paste0("Round.csv"))
      if (file.exists("Round.csv")) {
        
        message("'Round.csv' was saved in your current working directory.")
        
      } else {
        
        warning("'Round.csv' was not saved.")
        
      }
      break
      
    }
    
  }
  
  # Update the list of unwanted pairs with those already generated
  if (!is.null(unwantedpairs)) {
    
    readr::write_csv(store, unwantedpairs, append = TRUE)
    message(paste0("The following file containing unwanted pairs was updated: ", unwantedpairs))
    
    # Check the unwanted pairs file has only two columns
    uwp <- readr::read_csv(unwantedpairs, col_names = c("P1", "P2"))
    if (ncol(uwp) != 2) {
      warning("The updated file containing unwanted pairs does not have exactly two columns. Check that the original one ended with a new line.")
    }
    
  } else {
    
    readr::write_csv(store, "unwantedpairs.csv", append = TRUE)
    if (file.exists("unwantedpairs.csv")) {
      
      message("'unwantedpairs.csv' was saved in your current working directory.")
      
    } else{
      
      warning("'unwantedpairs.csv' was not saved.")
    }
    
  }
  
}
