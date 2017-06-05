
<!-- README.md is generated from README.Rmd. Please edit that file -->
Please note
-----------

This package is under construction and functionality may change. If this project is of interest please get in touch <josephadams@nhs.net>. I'm keen to hear feedback and I may be able to incorporate your specific needs into the package.

Introduction
------------

> Because they are simple to make and relatively straightforward to interpret, run charts are one of the most useful tools in quality improvement. - [NHS Scotland Quality Improvement Hub](http://www.qihub.scot.nhs.uk/knowledge-centre/quality-improvement-tools/run-chart.aspx).

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
#>         date base value trend shift
#> 1 2017-06-05    3     4    NA    NA
#> 2 2017-06-06    3     3    NA    NA
#> 3 2017-06-07    3     3    NA    NA
#> 4 2017-06-08    3     2    NA    NA
#> 5 2017-06-09    3     2    NA    NA
#> 6 2017-06-10    3     3    NA    NA
```

Installation
------------

This package is available for download from GitHub:

    devtools::install_github('josephjosephadams/runchart')
