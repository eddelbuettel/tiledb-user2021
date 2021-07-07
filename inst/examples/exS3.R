
## this requires AWS authentication to work

#uri <- "s3://namespace/bucket"          # change URI as needed

## you need either these two environment variables
##   AWS_SECRET_ACCESS_KEY
##   AWS_ACCESS_KEY_ID
## or set this in the TileDB config object

#fromSparseMatrix(spmat, uri)     # stored
#chk <- toSparseMatrix(uri)       # retrieved

## lazy eval: e.g. for subsets only requested data transferred to client


pp <- tiledb_array("s3://tiledb-conferences/useR-2021/palmer_penguins", as.data.frame=TRUE)
dat <- pp[]
head(dat)
