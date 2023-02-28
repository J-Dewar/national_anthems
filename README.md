
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Text and Sentiment analysis of National Anthems around the world

<!-- badges: start -->
<!-- badges: end -->

This is a repository for a collaborative project analyzing the lyrics of
national anthems for countries around the world (trying to include as
many as we can I think).

The data-set is derived from this [Github
repository](https://github.com/lucas-de-sa/national-anthems-clustering).
It contains the national anthems for 190 countries. This data-set is
only a stepping-off point from which we will create and verify our own
data-set with official lyrics and, potentially, added classifications.

Currently, the variables of the data-set are;

| Variables/ Column names | Description                                             |
|-------------------------|---------------------------------------------------------|
| country                 | name of country                                         |
| alpha_2                 | countries alpha 2 ISO-code                              |
| alpha_3                 | countries alpha 3 ISO-code                              |
| continent               | continent where country is located (Note: 6 continents) |
| anthem                  | lyrics of national anthem                               |

# To-Do

- Discover the official year that each national anthem was established,
  add to data set
- Determine whether lyrics in data set are the official lyrics
- Determine what countries may be omitted and whether these omissions
  should be added
- Determine whether revisions to national anthems exist, when were
  revisions made official
- Consider whether we should, for posterity, create a separate file with
  lyrics of national anthems in the national language of each respective
  country (especially considering that localization of translation may
  factor into any such analysis of sentiment)
- Consider creating our own classifications for either sentiment or text
  analysis

## Just some random instructions for us

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

![](README_files/figure-gfm/pressure-1.png)<!-- -->

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub.
