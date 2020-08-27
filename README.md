# Generate Coffee Roulette pairings

Generate rounds of pairs with no repeating names within each round, and no repeating pairs between rounds.

## Usage

1. Update names.csv with the names of participants, and include any unwanted pairings in unwantedpairs.csv in two columns.

1. Run the code, which outputs pairs for each round such that everyone participates in each round.

(Numerical factor within while loop multiplying nrow(pairs) should be < 1.0. Increasing it from its current value (0.8) may generate more unique rounds, but at the cost of longer execution times.)
