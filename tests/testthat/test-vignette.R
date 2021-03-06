context("use-vignette")

test_that("use_vignette() requires a package", {
  skip_if_not_installed("rmarkdown")

  scoped_temporary_project()
  expect_error(use_vignette(), "not an R package")
})

test_that("use_vignette() requires a `name`", {
  skip_if_not_installed("rmarkdown")

  scoped_temporary_package()
  expect_error(use_vignette(), "no default")
})

test_that("use_vignette() does the promised setup", {
  skip_if_not_installed("rmarkdown")

  scoped_temporary_package()
  use_vignette("name")

  ignores <- readLines(proj_path(".gitignore"), warn = FALSE)
  expect_true("inst/doc" %in% ignores)

  deps <- desc::desc_get_deps(proj_get())
  expect_true(
    all(c("knitr", "rmarkdown") %in% deps$package[deps$type == "Suggests"])
  )

  expect_identical(
    desc::desc_get_or_fail("VignetteBuilder", proj_get()),
    c(VignetteBuilder = "knitr")
  )
})
