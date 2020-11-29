
<!-- README.md is generated from README.Rmd. Please edit that file -->

# coffeeroulettepairs

<!-- badges: start -->

<!-- badges: end -->

Save time when organising a round of coffee roulette chats, in which
people who sign up are paired up randomly with each other. The code
geneates the random pairs for you, and ensures each person appears only
once in a single round. Provide a one column csv file containing a list
of names, and if desired, a two column csv file containing pairs which
you don’t want to appear in the random matches. The function
`random_pairs` writes a csv file called `Round.csv` containing the
random pairs, and a two column csv file called `unwantedpairs.csv`
containing the pairs which have just been matched, in addition to any
pre-exisiting pairs.

## Installation

You can install coffeeroulettepairs like so:

``` r
devtools::install_github("moj-analytical-services/coffee_roulette_pairs")
```

## Example

You can find an example list of names and unwanted pairs in
`inst/extsata`.

``` r
library(coffeeroulettepairs)
filename <- system.file("extdata", "names.csv", package = "coffeeroulettepairs")
unwantedpairs <- system.file("extdata", "unwantedpairs.csv", package = "coffeeroulettepairs")
random_pairs(filename = filename, unwantedpairs = unwantedpairs)
#> 
#> ── Column specification ────────────────────────────────────────────────────────
#> cols(
#>   name = col_character()
#> )
#> Warning in random_pairs(filename = filename, unwantedpairs = unwantedpairs): Odd
#> number of names! Removed the first name, i.e. Jack Jones
#> 
#> ── Column specification ────────────────────────────────────────────────────────
#> cols(
#>   P1 = col_character(),
#>   P2 = col_character()
#> )
```
