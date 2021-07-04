
## this requires AWS authentication to work

#uri <- "s3://namespace/bucket"          # change URI as needed

## you need either these two environment variables
##   AWS_SECRET_ACCESS_KEY
##   AWS_ACCESS_KEY_ID
## or set this in the TileDB config object

#fromSparseMatrix(spmat, uri)     # stored
#chk <- toSparseMatrix(uri)       # retrieved

## lazy eval: e.g. for subsets only requested data transferred to client


pp <- tiledb_array("s3://tiledb-dirk/palmer_penguins", as.data.frame=TRUE) # not a public s3 bucket
dat <- pp[]
head(dat)
