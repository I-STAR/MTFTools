# mtf-3d
MTF measurement in general (wire, Harp, slit, straight edge, sphere, wedge).

# demo scripts
See `./example_scripts/` for examples (using data from `example_datasets`, might be too large for GitLab).

# structure
- Spread function (LSF or ESF) is determined through `EsfCalc_XXX` (`XXX` is the type of measurement tool). 
- Then `sf2mtf` can be used to convert the spread function to MTF. 
- Also `sf2mtf_mult` can be used for error bar generation. 