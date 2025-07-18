import importlib, sys
pkg = importlib.import_module('applications.nlp')
sys.modules[__name__] = pkg
