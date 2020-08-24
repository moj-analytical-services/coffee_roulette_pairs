library(tidyverse)

# input the list of names, of even length
names <- read_csv("names.csv", col_names = FALSE) %>% 
  rename(Name = X1)

if(nrow(names) %% 2 != 0){
  warning(paste("Odd number of names! Removed the first name, i.e.", names[1,1]))
  names <- names %>% 
    slice(-1)
}

# generate all pairs
pairs <- as_tibble(t(combn(pull(names), 2))) %>% 
  rename(P1 = V1, P2 = V2)

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

# Generate sets of pairs in which names appear only once, and pairs are not repeated between sets
k <- 1
while(k < floor(0.8*nrow(pairs)/(nrow(names)/2))){

  #randomise the pairs
  rpairs <- pairs %>% 
    slice_sample(n=nrow(pairs))

  store <- rpairs %>% 
    slice_head()

  rpairs <- rpairs %>% 
    slice(-1)
  k <- 1
  for(j in seq(floor(nrow(pairs)/(nrow(names)/2)))){
    store <- rpairs %>% 
      slice_head()
    rpairs <- rpairs %>% 
      slice(-1)
    for (i in seq(nrow(rpairs))){
      if ((!rpairs$P1[i] %in% store$P1) & (!rpairs$P1[i] %in% store$P2) & (!rpairs$P2[i] %in% store$P1) & (!rpairs$P2[i] %in% store$P2)) {
        store <- store %>%
          bind_rows(rpairs[i,1:2])
      }
    }
    #rpairs <- rpairs %>% 
    #  anti_join(store, by=c("P1", "P2"))
    if(nrow(store)==(nrow(names)/2)){
      write_csv(store, paste0("Round", k,".csv"))
      k <- k + 1
      rpairs <- rpairs %>% 
        anti_join(store, by=c("P1", "P2"))
    }
  }
}