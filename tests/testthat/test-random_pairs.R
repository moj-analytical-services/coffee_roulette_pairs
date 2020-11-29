test_that("random_pairs() returns an error when no filename containing the list of names is provided", {

  expect_error(random_pairs())

  })

test_that("random_pairs() returns an error when a number is provided", {

  expect_error(random_pairs(2))

})
