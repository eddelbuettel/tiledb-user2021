
## Support package for TileDB tutorial at useR! 2021

This repository regroups example code for the tutorial as well as the pdf slides.

### Installation

To install, do either a direct installation from this repository via

```r
remotes::install_github('eddelbuettel/tiledb-user2021')
```

or use `install.packages()` with information on both this repository and CRAN
to resolve any possibly missing dependencies as well

```r
install.packages("tiledb.user2021", repos=c("https://eddelbuettel.github.io/tiledb-user2021/", "https://cloud.r-project.org"))
```

### Usage

Just load the package which displays a quick greeting:

```
> library(tiledb.user2021)
TileDB at useR! 2021 helper package. Use slides() to see the slides. Examples are in directory '/usr/local/lib/R/site-library/tiledb.user2021/examples'.
>
```

where the location of the examples will vary depending on where _you_ have R installed.


### Authors

Dirk Eddelbuettel and Aaron Wolen

We also copied one internal helper function from base R itself.

### Copyright

GPL (>= 2)
