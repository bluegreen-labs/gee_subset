import unittest
import os, re
from datetime import datetime
import pandas as pd
import ee
ee.Initialize()

import sys
sys.path.append(r"../..")
from gee_subset import gee_subset

class TimeseriesTest(unittest.TestCase):

    def setUp(self):
        pass

    def test_downloads(self):
        df = gee_subset(product = "MODIS/MYD09Q1", bands = ["sur_refl_b01", "sur_refl_b02"], start_date = "2015-01-01", end_date = "2015-12-31", latitude = 44, longitude = -72, scale = 30)

        df2 = gee_subset(product = "MODIS/MYD09Q1", bands = ["sur_refl_b02"], start_date = "2015-01-01", end_date = "2015-12-31", latitude = 44, longitude = -72, scale = 30)

        self.assertTrue(df.date.count() == 46)
        self.assertTrue(df2.date.count() == 46)
        
if __name__ == '__main__':
    unittest.main()


