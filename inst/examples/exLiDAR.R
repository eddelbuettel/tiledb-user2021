
lasfile <- "LAS_17258975.las"
if (!file.exists(lasfile)) {
    ## note: the file is 451 mb
    op <- options()                     # store
    options(timeout=3600)               # (much) more patience downloading
    lasfileurl <- file.path("https://clearinghouse.isgs.illinois.edu/las-east/cook/las/", lasfile)
    download.file(lasfileurl,lasfile)
    options(op)                         # reset
}

if (!dir.exists("las_array")) {
    wd <- getwd()
    cmd <- paste0("docker run --rm -ti -u 1000:1000 -v ", wd, ":/data ",
                  "-w /data tiledb/tiledb-geospatial pdal pipeline -i pipeline.json")
    system(cmd)                         # fancier return code check possible
}

library(tiledb)
arr <- tiledb_array("las_array", as.data.frame=TRUE)
selected_ranges(arr) <- list(X = cbind(1174100, 1174400),
                             Y = cbind(1899125, 1899250))
L <- arr[]
## print(dim(L))    # 108655 x 15

library(lidR)
L$ScanAngleRank <- as.integer(L$ScanAngleRank)
LL <- LAS(L)
plot(LL)
## plot(LL, backend="lidRviewer")   # if lidRviewer is installed


