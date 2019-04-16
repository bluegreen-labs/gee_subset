from distutils.core import setup
setup(
  name = 'gee_subset',
  packages = ['gee_subset'],
  version = '1.1.1',
  license = 'AGPL-3',
  description = 'Subset Google Earth Engine data',
  author = 'Koen Hufkens',
  author_email = 'koen.hufkens@gmail.com',
  url = 'https://github.com/khufkens/gee_subset',
  download_url = 'https://github.com/khufkens/gee_subset/archive/1.1.0.tar.gz',
  keywords = ['remote sensing','api','subsets'],
  classifiers = [
    # Status
    'Development Status :: 5 - Production/Stable',

    # Indicate who your project is intended for
    'Intended Audience :: Science/Research',
    'Topic :: Scientific/Engineering :: Information Analysis',

    # License
    'License :: OSI Approved :: GNU Affero General Public License v3',

    # Python versions supported
    'Programming Language :: Python :: 2.7',
    'Programming Language :: Python :: 2.6'
  ],
)
