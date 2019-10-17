import os
import os.path
import imp
from cerbero.config import Platform, Architecture, Distro,\
    DistroVersion, License, LibraryType
from cerbero.build.build import BuildType
from cerbero.build.source import SourceType
from cerbero.build.cookbook import CookBook
from cerbero.errors import FatalError, InvalidRecipeError
from cerbero.utils import _, shell, parse_file
from cerbero.build import recipe as crecipe

upstream_recipes_path = os.path.join(os.path.dirname(__file__), '..', 'cerbero', 'recipes')
m_path = os.path.join(upstream_recipes_path, 'custom.py')
if os.path.exists(m_path):
    custom = imp.load_source('custom', m_path)
else:
    custom = None

def upstream_recipe(name):
    env = {
        'Platform': Platform, 'Architecture': Architecture,
        'BuildType': BuildType, 'SourceType': SourceType,
        'Distro': Distro, 'DistroVersion': DistroVersion,
        'License': License, 'recipe': crecipe, 'os': os,
        'BuildSteps': crecipe.BuildSteps,
        'InvalidRecipeError': InvalidRecipeError,
        'FatalError': FatalError,
        'custom': custom, '_': _, 'shell': shell,
        'LibraryType' : LibraryType
    }
    filepath = os.path.join(upstream_recipes_path, name + CookBook.RECIPE_EXT)
    parse_file(filepath, env)
    recipe = env['Recipe']
    if hasattr(recipe, 'patches') and recipe.patches is not None:
        recipe.patches = [os.path.join(upstream_recipes_path, x) for x in recipe.patches]
    return recipe
