# Generate Coffee Roulette pairings

Generate rounds of pairs with no repeating names within each round, and no repeating pairs between rounds.

## Usage

1. Update names.csv with the names of participants, and include any unwanted pairings in unwantedpairs.csv in two columns.

1. Run the code, which outputs pairs for each round such that everyone participates in each round.

(factor within while loop on line 29 multiplying nrow(pairs) may be increased up to 1.0, generating more rounds but taking longer to run.)
