library(tiledb)                      # TileDB package
library(Matrix)                      # for sparse matrix functionality
uri <- tempfile()                    # array location
set.seed(123)                        # fix RNG seed

mat <- matrix(0, nrow=8, ncol=20)
mat[sample(seq_len(8*20), 15)] <- seq(1, 15)
spmat <- as(mat, "dgTMatrix")        # new sparse 'dgTMatrix'

fromSparseMatrix(spmat, uri)         # store the sparse matrix in TileDB
chk <- toSparseMatrix(uri)           # and retrieve it to check


chk     # to check retrieved sparse matrix



library(tiledb)          # load our package
uri <- tempfile()        # any local directory, more later on cloud access
## now sparse with a character and integer ('year') index colum
## with wider range than seen in the data for year we allow appending
fromDataFrame(palmerpenguins::penguins,  uri, sparse = TRUE,
              col_index = c("species", "year"),
              tile_domain=list(year=c(2000L, 2021L)))

x <- tiledb_array(uri, as.data.frame = TRUE, extended = FALSE)
newdf <- x[]             # full array (we can index rows and/or cols too)



x <- tiledb_array(uri, as.data.frame = TRUE, extended = FALSE)
selected_ranges(x) <- list(year=cbind(2007L, 2008L),
                           species=cbind("Gentoo", "Gentoo"))
newdf <- x[]


qc <- tiledb_query_condition_init("body_mass_g", 6000, "INT32", "GE")
query_condition(x) <- qc
newdf <- x[]

## if tiledb package from GitHub is used:
#qc <- parse_query_condition(body_mass_g >= 6000)
#query_condition(x) <- qc
#newdf <- x[]


x <- tiledb_array(uri, as.data.frame = TRUE, extended = FALSE)
attrs(x) <- c("species", "island", "sex")
