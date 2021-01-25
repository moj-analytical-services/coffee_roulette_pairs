
<!-- README.md is generated from README.Rmd. Please edit that file -->

# coffeeroulettepairs

<!-- badges: start -->

<!-- badges: end -->

Save time when organising a round of coffee roulette chats, in which
people who sign up are paired up randomly with each other\! The code
generates the random pairs for you, and ensures each person appears only
once in a single round.

## Installation

You can install coffeeroulettepairs like so:

``` r
devtools::install_github("moj-analytical-services/coffee_roulette_pairs")
```

## Usage

  - Create a one column csv file containing the list of names, and if
    required a two column csv file containing pairs which you don’t want
    to appear in the random matches.
  - Run the function `random_pairs`, which writes a new csv file called
    `Round.csv` containing the random pairs, and updates or creates a
    two column csv file called `unwantedpairs.csv`, containing the pairs
    which have just been matched, in addition to any pre-existing
    unwanted pairs.
  - **NB the output file `Round.csv` will be saved in your current
    working directory.**

## Example

You can find an example list of names and unwanted pairs in the
`inst/extdata` directory. The example below uses those files as an
illustration.

``` r
library(coffeeroulettepairs)

# Specify the file containing the names to be paired up as a string 
names <- system.file("extdata", "names.csv", package = "coffeeroulettepairs")

# Specify the file containing the unwanted pairs as a string 
uwp <- system.file("extdata", "unwantedpairs.csv", package = "coffeeroulettepairs")

# Run the random_pairs function. NB the output will be saved in your current working directory
random_pairs(filename = names, unwantedpairs = uwp)
#> Your current working directory is: /home/ms130/Misc/coffeeroulettepairs. Round.csv will be saved there.
#> 
#> ── Column specification ────────────────────────────────────────────────────────
#> cols(
#>   name = col_character()
#> )
#> Warning in random_pairs(filename = names, unwantedpairs = uwp): Odd number of
#> names! Removed the first name, i.e. Jack Jones
#> 
#> ── Column specification ────────────────────────────────────────────────────────
#> cols(
#>   P1 = col_character(),
#>   P2 = col_character()
#> )
#> Round.csv was saved in your current working directory.
#> The file containing unwanted pairs was updated.
```
