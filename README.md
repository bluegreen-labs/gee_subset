[![DOI](https://zenodo.org/badge/97874563.svg)](https://zenodo.org/badge/latestdoi/97874563)
<a href="https://www.buymeacoffee.com/H2wlgqCLO" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" height="21px" ></a>
<a href="https://liberapay.com/khufkens/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg" height="21px"></a>

# Google Earth Engine subset script & library

This is a small python script to subset GEE gridded data products into time series for a given location or list of locations. This script should make it easier to subset remote sensing time series for processing external to GEE. 

This in part replaces for example the ORNL DAAC MODIS subsets or Daymet web services, but extends these to higher resolution date such as Landsat and Sentinel. More so, it should also work on all other gridded products using the same product / band syntax (e.g. the MODIS phenology product MCD12Q2 or the MODIS snow product MOD10A1). If this code made your life easier please refer to it using the Zenodo citation and DOI (see below / medallion) in any research papers.

## Installation

clone the repository

```bash
git clone https://github.com/khufkens/google_earth_engine_subsets.git
```

Make sure you have a working Google Earth Engine python API setup. The installation instructions can be found on the [GEE developer site](https://developers.google.com/earth-engine/python_install).

## Use

Below you find an example call to the scrip which downloads MODIS MYD09Q1 (-p, --product) reflectance data for bands 1 and 2 (-b, --band) for a number of sites as listed in selected_sites.csv and saves the results on the users desktop (-d, --directory).

```bash
./gee_subset.py -p "MODIS/MYD09Q1" \
                -b "sur_refl_b01" "sur_refl_b02" \
                -f "~/Desktop/selected_sites.csv" \
                -d "/Users/foo/Desktop/"
```

``` bash
# prints output to console
./gee_subset.py -p "LANDSAT/LC08/C01/T1" \
                -b "B1" "B2" \
                -s "2015-01-01" \
                -e "2015-12-31" \
                -l 44.064665 -71.287575
```

Sites can be listed as a latitude longitude tuple using the -loc parameter, or by providing the before mentioned csv file (-f, --file parameter). Either one should be provided.

The csv file is a comma delimited file of the format:

	site, latitude, longitude.

A padding value can be provided (-pd, --pad) so one can download a rectangular window of data padded x km in either direction around a particular location. This option is limited by the maximum pixels which GEE can export. For normal use (i.e. 1 to 2 km padding) this should not present a problem for most products.

General help can be queried by calling:
```bash
./gee_subset.py -h
```

In addition the script can be loaded as a library in a python script by calling:

```python
import gee_subset
```
The function is called gee_subset(). Consult the script for correct parameter naming conventions. Currently minimum error trapping is provided.

## Data format

The output of the script is [tidy data](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html) in which each row is an observation. Multiple observations can be returned in case a padding value is specified. Multiple bands can be called at once by providing multiple valid bands as an argument. Multiple bands will be returned as columns in the tidy data format.

## Demo code

An example query, calling the python script from R, downloads two years (~100 data points) of Landsat 8 Tier 1 data for two bands (red, NIR) in ~8 seconds flat. Querying for a larger footprint (1x1 km footprint) only creates a small overhead (13 sec. query). The resulting figure for the point location with the derived NDVI values is shown below. The demo script to recreate this figure is included in the examples folder of the github repository.

![](examples/demo_vis.png?raw=true)

## References

Hufkens K. (2017) A Google Earth Engine time series subset script & library. DOI: 10.5281/zenodo.833789.
