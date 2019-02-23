
library(ggplot2)
library(maps)
library(mapproj)



#' Plot US postcodes on a map.
#'
#' Uses `mapdata::worldHires` to extract outline of Great Britain and Ireland and plots datapoints.
#'
#' @param dat Data frame with columns `longitude` and `latitude`
#' @param colour Colour of data points
#' @param size Size of data points
#' @param alpha Alpha of data points
#' @param title Map title
#'
#' @return An object of class `ggplot2`
#' @export
#'
#' @examples
plot_postcode <- function(dat,
                          colour = "blue", size = 0.1, alpha = 0.25,
                          title = NULL){
  uk <- map_data(
    "mapdata::worldHires",
    region = c(
      "UK:Great Britain",
      "UK:Northern Ireland",
      "UK:Scotland",
      "UK:Jersey",
      "UK:Guernsey",
      "Isle of Man",
      "Wales:Anglesey",
      "Ireland"
    )
  )

  p <- ggplot() +
    geom_polygon(
      data = uk,
      aes(x = long, y = lat, group = group),
      fill = "white", colour = "grey80"
    ) +
    geom_point(
      data = dat,
      aes(x = longitude, y = latitude),
      size = size, colour = colour, alpha = alpha
    ) +
    coord_map("conic", 55)

  if (!missing(title) && !is.null(title)) p <- p + ggtitle(title)

  p
}
