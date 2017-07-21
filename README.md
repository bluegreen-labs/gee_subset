# google_earth_engine_subsets

A small python script to subset GEE gridded data products.

This script should make it easier to subset remote sensing time series for processing external to GEE. This in parts replaces the ORNL DAAC MODIS subsets, but extends it to higher resolution date such as Landsat and Sentinel.

More so, it should also work on all other gridded products using the same product / band syntax.

## Installation

clone the repository

```bash
git clone https://github.com/khufkens/google_earth_engine_subsets.git
```

Make sure you have a working Google Earth Engine python API setup. The installation instructions can be found on the [GEE developer site](https://developers.google.com/earth-engine/python_install).

## Use

Below you find an example call to the scrip which downloads MODIS MYD09Q1 (-p, --product) reflectance data for bands 1 and 2 (-b, --band) for a number of sites as listed in selected_sites.csv and saves the results on the users desktop (-d, --directory).

```bash
./gee_subsets.py -p "MODIS/MYD09Q1" -b "sur_refl_b01" "sur_refl_b02" -f "~/Desktop/selected_sites.csv" -d "/Users/foo/Desktop/"
```

``` bash
./gee_subsets.py -p "LANDSAT/LC08/C01/T1" -b "B1" "B2" -s "2015-01-01" -e "2015-12-31" -loc 44.064665 -71.287575
```

Sites can be listed as a latitude longitude tuple using the -loc parameter, or by providing the before mentioned csv file (-f, --file parameter). Either one should be provided.

The csv file is a comma delimited file of the format:

	site, latitude, longitude.

A radius can be provided (-r, --radius) around which one can download a rectangular window of data (I know... but for simplicity this is called a radius).

General help can be queried by calling:
```bash
./gee_subsets.py -h
```

## Data format

The output of the script is tidy data which each row an observation. Multiple observations can be returned in case radius is specified. Multiple bands can be called at once by providing multiple valid bands as an argument. These multiple bands will be returned as columns in the tidy data format.