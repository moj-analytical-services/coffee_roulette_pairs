utils::globalVariables(c("P1", "P2"))


random_pairs <- function(file = NULL, unwantedpairs = NULL){

  if (is.null(file)) {
    stop("Please supply the path to the csv file containing the list of coffee roulette participants")
  }

  # Import the list of names
  names <- readr::read_csv(file, col_names = "name")

  # If not of even length, remove the first name from the list
  if(nrow(names) %% 2 != 0){
    warning(paste("Odd number of names! Removed the first name, i.e.", names[1,1]))
    names <- dplyr::slice(names, -1)
  }

  # # Generate all possible pairs
  pairs <- tibble::tibble("P1" = t(utils::combn(names$name, 2))[,1], "P2" = t(utils::combn(names$name, 2))[,2])

  # Remove unwanted pairs, if required
  if (!is.null(unwantedpairs)) {
    uwp <- readr::read_csv(unwantedpairs, col_names = c("P1", "P2"))
    ruwp <- dplyr::rename(uwp, P2 = P1, P1 = P2)
    uwp <- dplyr::bind_rows(uwp, ruwp)
    pairs <- dplyr::anti_join(pairs, uwp, by=c("P1", "P2"))
  }



}
