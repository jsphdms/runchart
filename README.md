
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
library(tibble)

n     <- 30
date  <- seq.Date(Sys.Date(), by = "day", length.out = n)
value <- c(0,1,5,2,3,8,2,2,3,4,7,4,3,4,2,3,1,2,3,2,8,9,7,8,7,9,NA,7,7,8)

df    <- data.frame(date  = date,
                    value = value)

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
as_tibble(runchart(df, rephase = TRUE, output = 'df'))
#> # A tibble: 30 × 10
#>          date value  base base_ext base_label base1 base2 base_ext1
#>        <date> <dbl> <dbl>    <dbl>      <dbl> <dbl> <dbl>     <dbl>
#> 1  2017-06-05     0     2        2          2     2    NA         2
#> 2  2017-06-06     1     2        2         NA     2    NA         2
#> 3  2017-06-07     5     2        2         NA     2    NA         2
#> 4  2017-06-08     2     2        2         NA     2    NA         2
#> 5  2017-06-09     3     2        2         NA     2    NA         2
#> 6  2017-06-10     8     2        2         NA     2    NA         2
#> 7  2017-06-11     2     2        2         NA     2    NA         2
#> 8  2017-06-12     2     2        2         NA     2    NA         2
#> 9  2017-06-13     3    NA        2         NA    NA    NA         2
#> 10 2017-06-14     4    NA        2         NA    NA    NA         2
#> # ... with 20 more rows, and 2 more variables: base_ext2 <dbl>,
#> #   shift <dbl>
```

Installation
------------

This package is available for download from GitHub:

    devtools::install_github('josephjosephadams/runchart')

### Things to Notice

There are several behaviours to notice in the plot above:

-   **Rephasing** for each sustained shift (9 consecutive points all above/below the baseline).

-   **Shifts** are identified (6 or more consecutive points all above/below the baseline).

-   **Missing values** are ignored. For example the 27th data point above is missing, which causes the rephased baseline to be longer than the first.

-   **Non-useful observations** are ignored. For example the 15th data point above lands exactly on the first baseline. Therefore it neither breaks nor contributes to the observed shift.

-   **Trends** are currently only available for fixed baselines (not rephased ones).
