# coffeeroulettepairs

Save time when organising a round of coffee roulette chats, in which
people who sign up are paired up randomly with each other! The code
generates the random pairs for you, and ensures each person appears only
once per round.

## Installation

You can install coffeeroulettepairs like so:

``` r
remotes::install_github("moj-analytical-services/coffee_roulette_pairs")
```

## Usage

1. Create a one column csv file (without a header) containing the names of participants.
1. If required, create a two column csv file (without a header) containing pairs of names which you
 don’t want to be matched together.
1. Run the `save_pairs` function, giving the path to the csv file containing names to the `names_file` argument, and if
 required give the path to the unwanted pairs csv file to the `unwantedpairs_file` argument.
 
## Result 

This will write a new csv file in the current working directory called `randompairs.csv` containing the random pairs of names. It also appends
to or creates a new two column csv file called `unwantedpairs.csv`, containing the pairs which have just been matched, 
in addition to any pre-existing unwanted pairs.

## Example

``` r
# Load the package
library(coffeeroulettepairs)

# Run the save_pairs function
save_pairs(names_file = 'path/to/names.csv', unwantedpairs_file = 'path/to/uwp.csv')
```
