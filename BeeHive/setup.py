import setuptools
from setuptools import setup

with open("README.md", "r") as fh:
    long_description = fh.read()

setup(
  name = 'BeeHiveOptimization',         # How you named your package folder (MyLib)
  version = '1.0.4',      # Start with a small number and increase it with every change you make
  license = 'MIT',        # Chose a license from here: https://help.github.com/articles/licensing-a-repository
  description = 'Implementation of beehive method (particle swarm optimization) for global optimization of multidimentional functions',   # Give a short description about your library
  long_description=long_description,
  long_description_content_type="text/markdown",
  author = 'Demetry Pascal',                   # Type in your name
  author_email = 'qtckpuhdsa@gmail.com',      # Type in your E-Mail
  url = 'https://github.com/PasaOpasen/BeehiveMethod',   # Provide either the link to your github or to your website
 # download_url = 'https://github.com/PasaOpasen/BeehiveMethod/archive/1.0.1.tar.gz',    # I explain this later on
  keywords = ['beehive_method', 'optimization', 'function-optimization', 'stochastic-optimization', 'swarm particle', 'particle swarm optimization'],   # Keywords that define your package best
  
  install_requires=[            # I get to this in a second
          'joblib',
          'numpy'
      ],
  packages = setuptools.find_packages(),
  classifiers=[
    'Development Status :: 4 - Beta',      # Chose either "3 - Alpha", "4 - Beta" or "5 - Production/Stable" as the current state of your package
    'Intended Audience :: Developers',      # Define that your audience are developers
    'Topic :: Software Development :: Build Tools',
    'License :: OSI Approved :: MIT License',   # Again, pick a license
    'Programming Language :: Python :: 3',      #Specify which pyhton versions that you want to support
    'Programming Language :: Python :: 3.6',
    'Programming Language :: Python :: 3.7',
    'Programming Language :: Python :: 3.8',
  ],
)