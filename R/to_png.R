#' Write base64 string to a PNG
#' @importFrom magick image_read image_resize image_write
#' @importFrom png writePNG
#' @importFrom base64enc base64decode
#' @export
to_png <- function(base64, file = tempfile(), resize = NULL){
  raw <- base64enc::base64decode(what = substr(base64, 23, nchar(base64)))
  png::writePNG(png::readPNG(raw), file)

  img <- magick::image_read(file) %>%
    magick::image_trim()

  if(!is.null(resize)){
    stopifnot(is.character(resize))

    img <- magick::image_resize(img, resize)

  }

  magick::image_write(img, file)

return(invisible(file))
}
