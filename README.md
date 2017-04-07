
<!-- README.md is generated from README.Rmd. Please edit that file -->
Introduction
------------

> Because they are simple to make and relatively straightforward to interpret, run charts are one of the most useful tools in quality improvement. - [NHS Scotland Quality Improvement Hub](http://www.qihub.scot.nhs.uk/knowledge-centre/quality-improvement-tools/run-chart.aspx).

Run charts[1] are non-trivial to automate. A number of solutions exist in the healthcare improvement community in Scotland. However the author is only aware of small-scale solutions such as scripts and Excel macros.

These kinds of approaches have the following limitations:

-   Version control is cumbersome and unrealistic.
-   Adding a separate script to an existing workflow is inconvenient and error prone.
-   Scripts are often written to operate under specific conditions; making wider adoption unlikely.
-   Testing edge cases is a time consuming task which is replicated with each new script or macro.

The `runchart` package aims to overcome these limitations by exporting a single, well tested, function of the same name: `runchart()`.

Getting Started
---------------

To download the package first ensure you are not behind a firewall or using a VPN[2]. Install the package using `install_github()`[3]:

    devtools::install_github('josephjosephadams/runchart')

The `runchart` package exports one simple function: `runchart()`. The only parameter is a numeric vector of non-zero length. It returns a data frame with 4 columns: `base`, `base_ext`, `shift`, and `val`.

For example:

``` r
library(runchart)
rc <- runchart(c(0,1,5,2,3,8,2,2,3,4,7,4,3,4,2,3,1,2,3,2,8,9,7,8,7,9,NA,7,7,8,6,5))
rc
#>    base base_ext shift val
#> 1   2.0      2.0    NA   0
#> 2   2.0      2.0    NA   1
#> 3   2.0      2.0    NA   5
#> 4   2.0      2.0    NA   2
#> 5   2.0      2.0    NA   3
#> 6   2.0      2.0    NA   8
#> 7   2.0      2.0    NA   2
#> 8   2.0      2.0    NA   2
#> 9    NA      2.0     3   3
#> 10   NA      2.0     4   4
#> 11   NA      2.0     7   7
#> 12   NA      2.0     4   4
#> 13   NA      2.0     3   3
#> 14   NA      2.0     4   4
#> 15   NA      2.0    NA   2
#> 16   NA      2.0     3   3
#> 17   NA      2.0    NA   1
#> 18   NA      2.0    NA   2
#> 19  7.5      7.5    NA   3
#> 20  7.5      7.5    NA   2
#> 21  7.5      7.5    NA   8
#> 22  7.5      7.5    NA   9
#> 23  7.5      7.5    NA   7
#> 24  7.5      7.5    NA   8
#> 25  7.5      7.5    NA   7
#> 26  7.5      7.5    NA   9
#> 27  7.5      7.5    NA  NA
#> 28  7.5      7.5    NA   7
#> 29   NA      7.5    NA   7
#> 30   NA      7.5    NA   8
#> 31   NA      7.5    NA   6
#> 32   NA      7.5    NA   5
```

Code for plotting the result might look like this:

``` r
library(ggplot2)
ggplot(rc, aes(1:nrow(rc), val)) +
  geom_line() +
  geom_line(aes(y = base), size = 1.3) +
  geom_line(aes(y = base_ext)) +
  geom_point(aes(y = shift), shape = 21, size = 3, colour = 'red',
             stroke = 2) +
  theme(axis.title.x=element_blank()) +
  theme(axis.title.y=element_blank())
```

<img src="README-unnamed-chunk-3-1.png" style="display: block; margin: auto;" />

Things to Notice
----------------

There are several behaviours to notice in the plot above:

-   **Rephasing** for each sustained shift (9 consecutive points all above/below the baseline).

-   **Shifts** are identified (6 or more consecutive points all above/below the baseline).

-   **Missing values** are ignored. For example the 27th data point above is missing, which causes the rephased baseline to be longer than the first.

-   **Non-useful observations** are ignored. For example the 15th data point above lands exactly on the first baseline. Therefore it neither breaks nor contributes to the observed shift.

The `runchart()` function has been well tested using the `testthat` package to correctly handle such different scenarios and edge cases.

[1] As defined by the NHS Scotland Quality Improvement Hub

[2] These can block installation from GitHub

[3] You may need to install the `devtools` package first.
