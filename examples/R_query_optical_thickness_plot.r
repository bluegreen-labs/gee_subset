# demo query to python from R using google_earth_engine_subset
#
# (please make sure to have the below libraries installed)
# This script clones the project in your home directory,
# you can remove these files afterward.

# load libraries
library(ggplot2)

# change this depending on system settings
python_path = "/usr/bin/env python"

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
band = "Cloud_Optical_Thickness_Liquid_Log_Mean_Mean Cloud_Fraction_Day_Mean_Mean"
start_date = "2000-01-01"
end_date = "2018-12-31"
location = "-0.2 11.6"

# store output in the R temporary directory
directory = tempdir()
out_file = paste0( directory, "/site_",
                   tail( unlist( strsplit( product, "[/]" ) ), n=1 ),
                   "_gee_subset.csv" )

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
df = read.table(out_file, sep = ",", header = TRUE )

# apply multiplier the cloud cover value, convert dates
df$cloud_thickness = df$Cloud_Optical_Thickness_Liquid_Log_Mean_Mean * 0.001
df$cloud_cover = df$Cloud_Fraction_Day_Mean_Mean * 0.0001
df$date = as.Date(df$date)

# convert to long format
df = df %>% gather(band, value, cloud_thickness, cloud_cover)

# write to file
write.table(df, "~/lope_cloud_data.csv",
            col.names = TRUE,
            row.names = FALSE,
            quote = FALSE,
            sep = ",")

# plot nicely with ggplot, inlcuding smoothed fit
p = ggplot(df, aes(date,value)) +
  xlab("") +
  ylab("Fractional Cover") +
  geom_smooth(span = 0.03, colour = "black") +
  geom_point() +
  ggtitle(sprintf("Cloud cover - processed in %s sec.",
                  round(proc_time,2))) +
  facet_wrap( ~ band, nrow = 2, scales = "free")

# save graph
png("~/lope_cloud_cover.png", 1800, 1200)
plot(p)
dev.off()

# remove downloaded file
file.remove(out_file)
