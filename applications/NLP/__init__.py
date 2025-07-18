import importlib, sys

# Re-export modules from the lowercase 'nlp' package so that they can be
# accessed as submodules of this package.
_lower_pkg = importlib.import_module('nlp')

for name in ('metamaplite', 'api'):
    module = importlib.import_module(f'nlp.{name}')
    sys.modules[f'{__name__}.{name}'] = module

# Expose attributes from the lowercase package at the package level
from nlp import *  # noqa
