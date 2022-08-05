names <- c('Jack', 'Matt', 'George', 'Simon', 'Craig', 'Fred')
names_wrong <- data.frame(P1=c('Jack', 'Matt', 'George'), P2=c('Simon', 'Craig', 'Fred'))
uwp <- data.frame(P1='Jack', P2='Matt')

test_that("generate_random_pairs", {
  expect_equal(2 * 2, 4)
})
