# demo query to python from R using google_earth_engine_subset
#
# (please make sure to have the below libraries installed)
# This script clones the project in your home directory,
# you can remove these files afterward.

# load libraries
library(ggplot2)

# change this depending on system settings
python_path = "/usr/bin/python" # on linux
#python_path = "/usr/local/bin/python" # on OSX

# clone the gee_subset project
# relies on git being installed
# and will work out of the box for most
# on OSX or Linux.
#
# basic gee_subset requirements apply
# mainly, having a working GEE python API install
setwd("~")
system("git clone https://github.com/khufkens/google_earth_engine_subsets.git")
path = "~/google_earth_engine_subsets/gee_subset/"

# set product parameters, such as
# product name, band(s) to query, start and end date of the range
# and the lcoation
product = "MODIS/006/MOD08_M3"
band = "Cloud_Optical_Thickness_Liquid_Log_Mean_Mean"
start_date = "2014-01-01"
end_date = "2017-12-31"
location = "44.064665 -71.287575"

# store output in the R temporary directory
directory = tempdir()

# make the gee_subset.py python call
# time the duration of the call for reporting
start = Sys.time()
system(sprintf("%s %s/gee_subset.py -p %s -b %s -s %s -e %s -l %s -d %s -sc 30",
               python_path,
               path,
               product,
               band,
               start_date,
               end_date,
               location,
               directory
               ), wait = TRUE)
end = Sys.time()
proc_time = as.vector(end - start)

# read in the data stored in the temporary directory
df = read.table( paste0( directory, "/site_", tail( unlist( strsplit( product, "[/]" ) ), n=1 ), "_gee_subset.csv" ), sep = ",", header = TRUE )

# apply multiplier the cloud cover value, less long
df$cloud_cover = df$Cloud_Optical_Thickness_Liquid_Log_Mean_Mean * 0.001
df$date = as.Date(df$date)

# plot nicely with ggplot, inlcuding smoothed fit
p = ggplot(df, aes(date,cloud_cover)) +
  xlab("") +
  ylab("Optical Thickness") +
  geom_smooth(span = 0.3, colour = "black") +
  geom_point() +
  ggtitle(sprintf("Cloud cover - processed in %s sec.",
                  round(proc_time,2)))
plot(p)
