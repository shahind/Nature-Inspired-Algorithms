from setuptools import setup

with open("README.md", "r") as fh:
    long_description = fh.read()

setup(
    name='bwo',
    version='0.1.2',
    author='Nathan A. Rooy',
    author_email='nathanrooy@gmail.com',
    url='https://github.com/nathanrooy/bwo',
    description='Black Widow Optimization',
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=['bwo'],
    python_requires='>=3.5',
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent'
    ]
)
