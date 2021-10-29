import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
  name = 'gee_subset',
  version = '1.1.2',
  license = 'AGPL-3',
  description = 'Subset Google Earth Engine data',
  long_description=long_description,
  long_description_content_type="text/markdown",
  author = 'Koen Hufkens',
  author_email = 'koen.hufkens@gmail.com',
  url = 'https://github.com/bluegreen-labs/gee_subset',
  project_urls={
        "Bug Tracker": "https://github.com/pypa/sampleproject/issues",
    },
  download_url = 'https://github.com/bluegreen-labs/gee_subset/archive/1.1.2.tar.gz',
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
    'Programming Language :: Python :: 3.6',
    'Programming Language :: Python :: 2.7',
    'Programming Language :: Python :: 2.6'
  ],
  package_dir={"": "src"},
  packages=setuptools.find_packages(where="src"),
  python_requires=">=3.6",
)