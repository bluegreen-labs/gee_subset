# demo query to python from R using google_earth_engine_subset
#
# (please make sure to have the below libraries installed)
# This script clones the project in your home directory,
# you can remove these files afterward.

# load libraries
library(ggplot2)
library(ggthemes)

# change this depending on system settings
python_path = "/usr/bin/python"

# clone the gee_subset project
# relies on git being installed
# and will work out of the box for most
# on OSX or Linux.
#
# basic gee_subset requirements apply
# mainly, having a working GEE python API install

library(tidyverse)

# read in IFPRI site locations
ifpri = readRDS("~/Dropbox/Research_Projects/IFPRI/manuscripts/remote_sensing_comparison/data/cropmonitor_subset.rds")

locations = ifpri %>%
  group_by(userfield) %>%
  summarise(lat = mean(latitude),
            lon = mean(longitude),
            site = unique(userfield),
            date = ifelse(any(first_lodging == "Yes"),
                          date[which(first_lodging == "Yes")],
                          NA)
            )
locations$date = as.Date(locations$date, origin = "1970-01-01")
locations = locations[!is.na(locations$date),]

setwd("~")
path = "~/Dropbox/Research_Projects/code_repository/bitbucket/gee_subset/gee_subset/"

# set product parameters, such as
# product name, band(s) to query, start and end date of the range
# and the lcoation
product = "COPERNICUS/S1_GRD"
bands = c("VH","VV")
start_date = "2016-10-15"
end_date = "2017-05-15"

# store output in the R temporary directory
directory = tempdir()

output = do.call("rbind", apply(locations, 1, function(location){
  
  data = lapply(bands, function(band){
  
    # make the gee_subset.py python call
    # time the duration of the call for reporting
    catch_error = try(system(sprintf("%s %s/gee_subset.py -p %s -b %s -s %s -e %s -l %s -d %s -sc 5",
                   python_path,
                   path,
                   product,
                   band,
                   start_date,
                   end_date,
                   paste(location[2:3], collapse = " "),
                   directory
                   ), wait = TRUE))
    
    # read in the data stored in the temporary directory
    filename = paste0( directory,
                       "/site_", tail( unlist( strsplit( product, "[/]" ) ), n=1 ),
                       "_gee_subset.csv" )
    
    df = try(read.table(filename ,
                        sep = ",",
                        header = TRUE, 
                        stringsAsFactors = FALSE))
    
    if (inherits(df, "try-error")){
      print(sprintf("error for: %s", location))
      return(NULL)
    }
    
    # translate date
    df$date = as.Date(df$date,"%Y-%m-%d %H:%M:%S")
    
    # remove temporary data not to cause conflicts
    file.remove(filename)
    
    # return data frame
    return(df)
  })
  
  # rename list elements
  names(data) = bands
  
  # merge data
  data = merge(data$VH, data$VV[c("date","VV")], by = "date", all.x = TRUE)
  
  # add site column
  data$site = location["site"]
  
  # return the data
  return(data)
}))

# create plot
gcc_facet = ggplot(data = output, aes(x = date, y = VH-VV )) + 
  geom_line() +
  geom_point() +
  xlab("Date") +
  ylab("Gcc 90") + facet_wrap(~ site, ncol = 4) +
  theme_minimal()

plot(gcc_facet)

# save stuff for later inspection
saveRDS(output,
        "~/Dropbox/Research_Projects/IFPRI/data/sentinel1_radar_data_lodging_sites.rds")
