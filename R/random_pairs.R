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

  if (is.null(filename)) {
    stop("Please supply the path to the csv file containing the list of coffee roulette participants")
  }

  # Import the list of names
  names <- readr::read_csv(filename, col_names = "name")

  # If not of even length, remove the first name from the list
  if(nrow(names) %% 2 != 0){
    warning(paste("Odd number of names! Removed the first name, i.e.", names[1,1]))
    names <- dplyr::slice(names, -1)
  }

  # # Generate all unique pairs
  pairs <- tibble::tibble("P1" = t(utils::combn(names$name, 2))[,1], "P2" = t(utils::combn(names$name, 2))[,2])

  # Remove unwanted pairs, if required
  if (!is.null(unwantedpairs)) {
    uwp <- readr::read_csv(unwantedpairs, col_names = c("P1", "P2"))
    ruwp <- dplyr::rename(uwp, P2 = P1, P1 = P2)
    uwp <- dplyr::bind_rows(uwp, ruwp)
    pairs <- dplyr::anti_join(pairs, uwp, by=c("P1", "P2"))
  }

  # Randomise the pairs
  rpairs <- dplyr::slice_sample(pairs, n = nrow(pairs))

  # Add the first pair to the store
  store <- dplyr::slice_head(rpairs)

  # Pairs per round
  ppr <- nrow(names)/2

  # Counts the number of pairs added to store
  k <- 1

  # Going though each pair in rpairs, only add it to the store if each name in the pair is not already present in any pair in the store
  for (i in seq(nrow(rpairs))){

    if ((!rpairs$P1[i] %in% store$P1) & (!rpairs$P1[i] %in% store$P2) & (!rpairs$P2[i] %in% store$P1) & (!rpairs$P2[i] %in% store$P2)) {

          store <- dplyr::bind_rows(store, rpairs[i,1:2])
          k <- k + 1
    }

    # If the number of pairs for a round have been store, write out the pairs, and break the loop
    if (k == ppr){

      readr::write_csv(store, paste0("Round.csv"))
      break

    }

  }

  # Update the list of unwanted pairs with those already generated, and update unwantedpairs.csv
  if (!is.null(unwantedpairs)) {
    readr::write_csv(store, unwantedpairs, append = TRUE)
  } else {

    readr::write_csv(store, "unwantedpairs.csv", append = TRUE)
  }

}
