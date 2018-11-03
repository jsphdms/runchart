
<!-- README.md is generated from README.Rmd. Please edit that file -->
runchart
--------

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip) [![Travis-CI Build Status](https://travis-ci.org/jsphdms/runchart.svg?branch=master)](https://travis-ci.org/jsphdms/runchart) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/jsphdms/runchart?branch=master&svg=true)](https://ci.appveyor.com/project/jsphdms/runchart) [![Coverage status](https://codecov.io/gh/jsphdms/runchart/branch/master/graph/badge.svg)](https://codecov.io/github/jsphdms/runchart?branch=master)

> A run chart is a simple analytical tool that helps us understand changes in data over time. - [NHS Healthcare Improvement Scotland](http://www.healthcareimprovementscotland.org/previous_resources/implementation_support/guide_to_using_run_charts.aspx).

A number of R packages exist to automate statistical process control charts. For example:

-   [qicharts](https://cran.r-project.org/web/packages/qicharts/index.html)
-   [qcc](https://cran.r-project.org/web/packages/qcc/index.html)
-   [ggQC](https://cran.r-project.org/web/packages/ggQC/index.html)

The `runchart` package is different from the above because it focusses solely on run charts and provides the ability to automatically rephase baselines. The package exports a single easy to use function `runchart()`.

Examples
--------

By default - shifts and trends are displayed (triggering at 6 and 5 consecutive points respectively) and the baseline is not rephased:

``` r
library(runchart)
library(ggplot2)

df <- data.frame(date  = seq.Date(Sys.Date(), by = "day", length.out = 30),
                 value = c(4,3,3,2,2,3,3,4,4,4,4,3,3,2,2,1,2,1,0,3,3,4,5,6,7,9,8,7,6,6))

runchart(df)
```

<img src="README-unnamed-chunk-2-1.png" style="display: block; margin: auto;" />

Both shifts and trends can be independantly suppressed. The baseline can be rephased (triggering at 9 consecutive points):

``` r
runchart(df, shift = FALSE, trend = FALSE, rephase = TRUE)
```

<img src="README-unnamed-chunk-3-1.png" style="display: block; margin: auto;" />

Access the fields behind these plots by setting the output parameter to `df`:

``` r
head(runchart(df, output = 'df'))
#>         date base value shift
#> 1 2018-11-03    3     4    NA
#> 2 2018-11-04    3     3    NA
#> 3 2018-11-05    3     3    NA
#> 4 2018-11-06    3     2    NA
#> 5 2018-11-07    3     2    NA
#> 6 2018-11-08    3     3    NA
```

Installation
------------

This package is available for download from GitHub:

    devtools::install_github('jsphdms/runchart')

Contributing
------------

This project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
