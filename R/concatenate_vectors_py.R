#' Add or Concatenate Objects via Python
#'
#' @description
#' A wrapper function that passes two R objects to a Python script.
#' Depending on the input types, Python will either sum them (if numeric)
#' or concatenate them (if vectors/strings).
#'
#' @param x Numeric or vector
#' @param y Numeric or vector to be added to/combined with
#'
#' @return The result of the Python add_numbers function depending on the input types.
#'
#' @examples
#' \dontrun{
#' # Adding numbers
#' concatenate_vectors_py(10, 20)
#'
#' # Concatenating vectors
#' concatenate_vectors_py(c('a','b'), c('c','d'))
#'
#' @export
concatenate_vectors_py <- function(x,y) {
  source_python("python/add_numbers.py")
  return (add_numbers(x,y))
}
