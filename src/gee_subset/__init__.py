__version__ = '1.1.0'

try:
    from gee_subset import gee_subset
except ImportError:
    from gee_subset.gee_subset import gee_subset

__all__ = ["gee_subset"]
