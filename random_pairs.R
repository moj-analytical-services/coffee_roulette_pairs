library(tidyverse)

# minimum version of tidyverse packages required
if (compareVersion(as.character(packageVersion("dplyr")),"1.0.0") == -1 ) {
  stop("dplyr version must be at least 1.0.0, please update")
}
if (compareVersion(as.character(packageVersion("readr")),"1.3.1") == -1 ) {
  stop("readr version must be at least 1.3.1, please update")
}
if (compareVersion(as.character(packageVersion("tibble")),"3.0.1") == -1 ) {
  stop("tibble version must be at least 3.0.1, please update")
}

# This parameter determines how many rounds are output, and how long the code takes to complete. 
# It can take values in the range 0.0 < alpha < 1.0
alpha <- 0.6

# input the list of names, of even length
names <- read_csv("names.csv", col_names = FALSE) %>% 
  rename(Name = X1)

if(nrow(names) %% 2 != 0){
  warning(paste("Odd number of names! Removed the first name, i.e.", names[1,1]))
  names <- names %>% 
    slice(-1)
}

# generate all pairs
pairs <- as_tibble(t(combn(pull(names), 2)), .name_repair = "unique") %>% 
  rename(P1 = ...1, P2 = ...2)

# remove unwanted pairs
if (file.exists("unwantedpairs.csv")) {
  uwp <- read_csv("unwantedpairs.csv", col_names = FALSE) %>% 
    rename(P1 = X1, P2=X2)
  ruwp <- uwp %>% 
    rename(P2=P1,P1=P2)
  uwp <- uwp %>% 
    bind_rows(ruwp)
  pairs <- pairs %>% 
    anti_join(uwp, by=c("P1", "P2"))
}

# Generate sets of pairs in which names appear only once in each round, and pairs are not repeated between rounds
k <- 1
while(k < floor(alpha*nrow(pairs)/(nrow(names)/2))){

  # Randomise the pairs
  rpairs <- pairs %>% 
    slice_sample(n=nrow(pairs))
  
  # Add the first pair to the store
  store <- rpairs %>% 
    slice_head()

  # Remove the corresponding pair from rpairs
  rpairs <- rpairs %>% 
    slice(-1)
  
  # Initialise a counter
  k <- 1
  
  for(j in seq(floor(nrow(pairs)/(nrow(names)/2)))){
    # Add the first pair to the store
    store <- rpairs %>% 
      slice_head()
    
    # Remove the corresponding pair from rpairs
    rpairs <- rpairs %>% 
      slice(-1)
    
    # Going though each pair in rpairs, only add it to the store if each name in the pair is not already present in any pair in the store
    for (i in seq(nrow(rpairs))){
      if ((!rpairs$P1[i] %in% store$P1) & (!rpairs$P1[i] %in% store$P2) & (!rpairs$P2[i] %in% store$P1) & (!rpairs$P2[i] %in% store$P2)) {
        store <- store %>%
          bind_rows(rpairs[i,1:2])
      }
    }

    # If there are sufficient names in the store for a single round, print out the pairs
    if(nrow(store)==(nrow(names)/2)){
      write_csv(store, paste0("Round_", stringr::str_pad(k,2, side="left", pad="0"),".csv"))
      k <- k + 1
      # remove these pairs printed out from rpairs, so that they don't appear again
      rpairs <- rpairs %>% 
        anti_join(store, by=c("P1", "P2"))
    }
  }
}

# Update the list of unwanted pairs with those already generated, and update unwantedpairs.csv 

uwp <- pairs %>% 
  anti_join(rpairs, by=c("P1","P2"))

write_csv(uwp, "unwantedpairs.csv", append = TRUE)
