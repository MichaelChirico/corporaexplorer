library(corporaexplorer)
library(shinytest)

context("Explorer: Date test")

test_that("Explorer: Dates work", {
    app <- shinytest::ShinyDriver$new("..")
    app$snapshotInit("date_test")
    app$snapshot()
    app$setInputs(search_text = "october")
    app$setInputs(trykk = "click")

    output <- app$getValue(name = "date_slider")

    expect_equal(output[1], 2011)
    expect_equal(output[2], 2020)

})

test_that("Explorer: Year and date ranges", {
    app <- shinytest::ShinyDriver$new("..")
    app$snapshotInit("date_test_set_dates")

    app$setInputs(date_slider = c(2012, 2019))
    app$setInputs(trykk = "click")
    app$snapshot()
    a <- app$getAllValues()$export$nums
    expect_equal(a, 2012)

    app$setInputs(years_or_dates = "Date range")
    app$setInputs(date_calendar = as.Date(c("2014-01-01", "2016-01-01")))
    app$setInputs(trykk = "click")
    app$snapshot()
    a <- app$getAllValues()$export$nums
    expect_equal(a, as.Date("2014-01-01"))

})
