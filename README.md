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

1. Create a one column csv file (without a column name) containing the names of participants.
1. If required, create a two column csv file (without column names) containing pairs of names which you
 **don’t** want to be matched together.
1. Run the `save_pairs` function (see below), giving the path to the csv file containing names to the `names_file` argument, and if
 required the path to the unwanted pairs csv file to the `unwantedpairs_file` argument.
 
## Result 

This will write a new csv file in the current working directory called `randompairs.csv` containing the random pairs of names. It also appends
to an existing, or creates a new two column csv file called `unwantedpairs.csv`, containing the pairs which have just been matched, 
in addition to any pre-existing unwanted pairs.

You now have a round of random pairs of names, in which every one is matched with some one else, and everyone appears only once!

## Example

``` r
# Load the package
library(coffeeroulettepairs)

# Run the save_pairs function
save_pairs(names_file = 'path/to/names.csv', unwantedpairs_file = 'path/to/uwp.csv')
```

## Caveats

If too many unwanted pairs are provided, the code might not find sufficient unique random pairs to match everyone with a partner after making a number of attempts defined by the `no_of_tries` parameter (default value = 20), while ensuring no name appears more than once. In this case either:
1. Increase the value of the `no_of_tries` parameter, and try running the function again. The code re-randomizes the list of pairs each time it attempts to fill a round, so will have another chance at doing so.
1. Keep running the function, until sufficient pairs have been generated.
1. Remove some unwanted pairs, and run the function again, which makes it more likely to generate a complete round.

## How it works

1. From the list of names provided, all possible unique pairs are generated, i.e. the order of names in a pair is irrelevant, so the Matt-John pair appear once, rather than Matt-John and John-Matt.
1. If unwanted pairs are provided, they are removed from the list of all pairs.
1. The remaining pairs are randomized.
1. Starting from the first pair in the list of all pairs, additional pairs are added to a new list, as long as neither name in the next pair already appears in the new list. This is to ensure each name 
appears only once.
1. This process is repeated a set number of times, given by the `no_of_tried` parameter, until enough random pairs are generated such that everyone is matched with some one else.
1. The round of random pairs is written to a file, and those pairs are also added to an existing or new file containing unwanted pairs for future rounds (since they have already been matched). Otherwise, an error is printed if not enough pairs were generated for a round meeting the above criteria.

## Feedback

Feedback, comments, suggestions for improvements are always welcome! Please raise an issue or create a pull request.
