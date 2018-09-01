# demo query to python from R using google_earth_engine_subset
#
# (please make sure to have the below libraries installed)
# This script clones the project in your home directory,
# you can remove these files afterward.

# load libraries
library(ggplot2)
library(ggthemes)
library(raster)
library(googledrive) # make sure to authenticate first

# change this depending on system settings
python_path <- "/usr/bin/python"
path <- tempdir()
setwd(path)
system("git clone https://github.com/khufkens/gee_subset.git")

# WARNING: removes the gee_subset folder
try(drive_rm("gee_subset"))

# set product parameters, such as
# product name, band(s) to query, start and end date of the range
# and the lcoation
product <- "COPERNICUS/S1_GRD"
bands <- c("VV")
start_date <- "2016-10-15"
end_date <- "2017-05-15"
location <- "48.819541 3.009227"

# make the gee_subset.py python call
# time the duration of the call for reporting
catch_error = try(system(sprintf("%s %s/gee_subset/gee_subset/gee_subset.py -p %s -b %s -s %s -e %s -l %s -i True",
                   python_path,
                   path,
                   product,
                   band,
                   start_date,
                   end_date,
                   location
                   ), wait = TRUE))

# sleep for a minute to generate the data
# might be longer for other examples, in this
# case the below drive_ls() query can be put
# in a while loop
Sys.sleep(60)

# list files downloaded to your google drive
files <- drive_ls("gee_subset")

apply(files, 1, function(file){
  drive_download(file = file$name)
})

# load data
s <- stack(list.files(getwd(),"*.tif", full.names = TRUE))

# animate stack
plot_map <- function(r){

  theme_map <- function(...) {
    theme_minimal() +
      ggplot2::theme(
        text = ggplot2::element_text(family = "Arial",
                                     color = "#22211d",
                                     size = 18),
        axis.line = ggplot2::element_blank(),
        axis.text.x = ggplot2::element_blank(),
        axis.text.y = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank(),
        axis.title.x = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_blank(),
        panel.grid.major = ggplot2::element_line(color = "#ebebe5", size = 0.2),
        panel.grid.minor = ggplot2::element_blank(),
        plot.background = ggplot2::element_rect(fill = "#f5f5f2", color = NA),
        panel.background = ggplot2::element_rect(fill = "#f5f5f2", color = NA),
        legend.background = ggplot2::element_rect(fill = "#f5f5f2", color = NA),
        panel.border = ggplot2::element_blank(),
        ...
      )
  }
    
  raster_to_df <- function(r){
    r <- as.data.frame(as(r, "SpatialPixelsDataFrame"))
    colnames(r) <- c("value", "x", "y")
    return(r)
  }
  
  # define a colour palette to be used, spectral sucks but is the only
  # thing that can represent these highly non linear data well (even after
  # a sqrt transform)
  myPalette <- grDevices::colorRampPalette(
    rev(RColorBrewer::brewer.pal(11, "Spectral")))
  
  ggplot() +  
    geom_tile(data=raster_to_df(r), aes(x=x, y=y, fill=value)) +
    theme_map() +
    ggplot2::coord_equal() +
    ggplot2::labs(x = NULL,
                  y = NULL,
                  title = "Flooding in the Paris region 2016",
                  subtitle = "Sentinel 1 - VV polarization",
                  caption = "graphics by @koen_hufkens") +
    ggplot2::theme(legend.position = "bottom") +
    ggplot2::scale_fill_gradientn(
      colours = myPalette(100),
      name = "decibels (dB)",
      limits = c(-50, 0),
      guide = ggplot2::guide_colourbar(
        direction = "horizontal",
        barwidth = unit(0.5, units = "npc"),
        keyheight = unit(2, units = "mm"),
        keywidth = unit(50, units = "mm"),
        title.position = 'top',
        title.hjust = 0.5,
        label.hjust = 1,
        byrow = T,
        label.position = "bottom"
      )
    )
}

animate_stack <- function(s){
  lapply(names(s), function(l){
    p <- plot_map(s[[l]])
    plot(p)
  })
}

saveGIF({
  ani.options(interval = 0.3)
  animate_stack(s)},
  movie.name = "~/test.gif",
  ani.width = 600,
  ani.height = 600)


