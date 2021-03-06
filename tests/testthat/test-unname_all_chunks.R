context("test-unname_all_chunks")

test_that("unname_all_chunks works", {
  # check arg of tempdir
  R_version <- paste(R.version$major,
                     R.version$minor,
                     sep = ".")

  skip_if_not(R_version >= "3.5.0")

  temp_file_path <- file.path(tempdir(check = TRUE), "example4.Rmd")

  file.copy(system.file("examples", "example4.Rmd", package = "namer"),
            temp_file_path)
  unname_all_chunks(temp_file_path)

  lines <- readLines(temp_file_path)
  chunk_info <- get_chunk_info(lines)

  testthat::expect_true(all(is.na(chunk_info$name[2:5])))

  rendering <- rmarkdown::render(temp_file_path)
  testthat::expect_is(rendering, "character")

  file.remove(temp_file_path)

  basename <- fs::path_ext_remove(temp_file_path)

  file.remove(paste0(basename, ".html"))
})
